from terraform_data_pipeline import TerraformDataPipeline
from dataset_filter import DatasetFilter
from terraform_scraper import IntegratedTerraformPipeline
import os
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
