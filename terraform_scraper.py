import os
import tempfile
import requests
from github import Github
import git
from tqdm import tqdm

class TerraformGitHubScraper:
    def __init__(self, github_token, output_dir):
        self.github_token = github_token
        self.output_dir = output_dir
        self.g = Github(self.github_token)

    def search_terraform_repos(self, max_repos=100):
        query = "language:HCL filename:.tf"
        repos = self.g.search_repositories(query=query, sort="stars", order="desc")
        return list(repos)[:max_repos]

    def clone_repo(self, repo, temp_dir):
        repo_dir = os.path.join(temp_dir, repo.name)
        git.Repo.clone_from(repo.clone_url, repo_dir)
        return repo_dir

    def scrape_terraform_files(self, max_repos=100):
        repos = self.search_terraform_repos(max_repos)
        terraform_files = []

        with tempfile.TemporaryDirectory() as temp_dir:
            for repo in tqdm(repos, desc="Scraping repositories"):
                try:
                    repo_dir = self.clone_repo(repo, temp_dir)
                    for root, _, files in os.walk(repo_dir):
                        for file in files:
                            if file.endswith('.tf'):
                                file_path = os.path.join(root, file)
                                with open(file_path, 'r') as f:
                                    content = f.read()
                                terraform_files.append({
                                    "repo": repo.full_name,
                                    "file_path": os.path.relpath(file_path, repo_dir),
                                    "content": content
                                })
                except Exception as e:
                    print(f"Error processing repo {repo.full_name}: {str(e)}")

        return terraform_files

    def save_terraform_files(self, terraform_files):
        os.makedirs(self.output_dir, exist_ok=True)
        for i, tf_file in enumerate(terraform_files):
            file_name = f"terraform_file_{i}.tf"
            file_path = os.path.join(self.output_dir, file_name)
            with open(file_path, 'w') as f:
                f.write(tf_file["content"])

# Integrate with existing TerraformDataPipeline
class IntegratedTerraformPipeline(TerraformDataPipeline):
    def __init__(self, model_name, output_dir, github_token):
        super().__init__(model_name, output_dir)
        self.scraper = TerraformGitHubScraper(github_token, os.path.join(output_dir, "scraped_terraform"))

    def scrape_and_process(self, max_repos=100):
        print("Scraping Terraform repositories from GitHub...")
        terraform_files = self.scraper.scrape_terraform_files(max_repos)
        self.scraper.save_terraform_files(terraform_files)

        print("Processing scraped Terraform files...")
        dataset = []
        for tf_file in tqdm(terraform_files, desc="Processing files"):
            code = tf_file["content"]
            summary = self.generate_summary(code)
            dataset.append({
                "instruction": summary,
                "code": code,
                "source_repo": tf_file["repo"],
                "source_file": tf_file["file_path"]
            })

        return dataset

def main():
    github_token = os.environ.get("GITHUB_TOKEN")
    if not github_token:
        raise ValueError("Please set the GITHUB_TOKEN environment variable")

    pipeline = IntegratedTerraformPipeline(
        model_name="meta-llama/Llama-2-7b-hf",
        output_dir="./terraform_dataset",
        github_token=github_token
    )

    print("Scraping and processing Terraform files...")
    dataset = pipeline.scrape_and_process(max_repos=100)

    print("Filtering dataset...")
    data_filter = DatasetFilter()
    filtered_dataset = data_filter.filter_dataset(dataset)

    print("Saving dataset...")
    pipeline.save_dataset(filtered_dataset)

    print(f"Generated {len(filtered_dataset)} instruction-code pairs")

if __name__ == "__main__":
    main()