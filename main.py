from terraform_data_pipeline import TerraformDataPipeline
from dataset_filter import DatasetFilter
def main():
    # Initialize the pipeline with your chosen LLM
    pipeline = TerraformDataPipeline(
        model_name="meta-llama/Llama-2-7b-hf",  # or any other suitable model
        output_dir="./terraform_dataset"
    )
    
    # Path to your scraped Terraform repositories
    repo_dir = "./terraform_repos"
    
    # Generate the dataset
    print("Generating dataset...")
    dataset = pipeline.create_dataset(repo_dir)
    
    # Save the dataset
    print("Saving dataset...")
    pipeline.save_dataset(dataset)
    
    print(f"Generated {len(dataset)} instruction-code pairs")

if __name__ == "__main__":
    main()