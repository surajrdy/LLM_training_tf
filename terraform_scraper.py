from terraform_data_pipeline import TerraformDataPipeline
from dataset_filter import DatasetFilter
import os
import requests
from github import Github
from tqdm import tqdm
import time

class TerraformGitHubScraper:
    def __init__(self, github_token, output_dir):
        self.github_token = github_token
        self.output_dir = output_dir
        self.g = Github(self.github_token)
        self.rate_limit_threshold = 10  # Threshold to start rate limit handling

    def search_terraform_files(self, max_files=1000):
        query = "extension:tf language:HCL"
        files = self.g.search_code(query=query, order="desc")
        return files[:max_files]

    def download_file_content(self, file_url):
        headers = {'Authorization': f'token {self.github_token}'}
        response = requests.get(file_url, headers=headers)
        if response.status_code == 200:
            return response.text
        else:
            print(f"Failed to download file {file_url}: {response.status_code}")
            return None

    def scrape_terraform_files(self, max_files=1000):
        files = self.search_terraform_files(max_files)
        terraform_files = []

        for file in tqdm(files, desc="Scraping Terraform files"):
            try:
                # Handle rate limits
                rate_limit = self.g.get_rate_limit()
                if rate_limit.search.remaining < self.rate_limit_threshold:
                    reset_timestamp = rate_limit.search.reset.timestamp()
                    sleep_time = reset_timestamp - time.time() + 5  # Adding a buffer
                    print(f"Rate limit reached. Sleeping for {sleep_time} seconds.")
                    time.sleep(sleep_time)

                file_content = self.download_file_content(file.download_url)
                if file_content:
                    terraform_files.append({
                        "repo": file.repository.full_name,
                        "file_path": file.path,
                        "content": file_content
                    })
            except Exception as e:
                print(f"Error processing file {file.path} in repo {file.repository.full_name}: {str(e)}")

        return terraform_files

    def save_terraform_files(self, terraform_files):
        os.makedirs(self.output_dir, exist_ok=True)
        for tf_file in terraform_files:
            # Create directory structure matching the repository and file path
            repo_dir = os.path.join(self.output_dir, tf_file["repo"].replace("/", "_"))
            os.makedirs(repo_dir, exist_ok=True)
            file_name = tf_file["file_path"].replace("/", "_")
            file_path = os.path.join(repo_dir, file_name)
            with open(file_path, 'w') as f:
                f.write(tf_file["content"])

class IntegratedTerraformPipeline:
    def __init__(self, api_key, output_dir, github_token):
        self.pipeline = TerraformDataPipeline(api_key, output_dir)
        self.scraper = TerraformGitHubScraper(github_token, os.path.join(output_dir, "scraped_terraform"))

    def scrape_and_process(self, max_files=1000):
        print("Scraping Terraform files from GitHub...")
        terraform_files = self.scraper.scrape_terraform_files(max_files)
        self.scraper.save_terraform_files(terraform_files)

        print("Processing scraped Terraform files...")
        dataset = []
        for tf_file in tqdm(terraform_files, desc="Processing files"):
            code = tf_file["content"]
            summary = self.pipeline.generate_summary(code)
            dataset.append({
                "instruction": summary,
                "code": code,
                "source_repo": tf_file["repo"],
                "source_file": tf_file["file_path"]
            })

        return dataset

def main():
    github_token = os.environ.get("GITHUB_TOKEN")
    anthropic_api_key = os.environ.get("ANTHROPIC_API_KEY")
    if not github_token:
        raise ValueError("Please set the GITHUB_TOKEN environment variable")
    if not anthropic_api_key:
        raise ValueError("Please set the ANTHROPIC_API_KEY environment variable")

    pipeline = IntegratedTerraformPipeline(
        api_key=anthropic_api_key,
        output_dir="./terraform_dataset",
        github_token=github_token
    )

    print("Scraping and processing Terraform files...")
    dataset = pipeline.scrape_and_process(max_files=1000)

    print("Filtering dataset...")
    data_filter = DatasetFilter()
    filtered_dataset = data_filter.filter_dataset(dataset)

    print("Saving dataset...")
    pipeline.pipeline.save_dataset(filtered_dataset)

    print(f"Generated {len(filtered_dataset)} instruction-code pairs")

if __name__ == "__main__":
    main()

