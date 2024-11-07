import os
import glob
from transformers import AutoModelForCausalLM, AutoTokenizer
import json
from concurrent.futures import ThreadPoolExecutor

class TerraformDataPipeline:
    def __init__(self, model_name, output_dir):
        self.model = AutoModelForCausalLM.from_pretrained(model_name)
        self.tokenizer = AutoTokenizer.from_pretrained(model_name)
        self.output_dir = output_dir
        
    def collect_terraform_files(self, repo_dir):
        """Collect all Terraform files from the repository"""
        tf_files = []
        for ext in ['*.tf', '*.tfvars']:
            tf_files.extend(glob.glob(f"{repo_dir}/**/{ext}", recursive=True))
        return tf_files

    def preprocess_code(self, file_path):
        """Extract and clean Terraform code"""
        try:
            with open(file_path, 'r') as f:
                code = f.read()
            # Remove comments and empty lines
            cleaned_code = '\n'.join(
                line for line in code.split('\n')
                if not line.strip().startswith('#') and line.strip()
            )
            return cleaned_code
        except Exception as e:
            print(f"Error processing {file_path}: {e}")
            return None

    def generate_summary(self, code):
        """Generate natural language summary of Terraform code using LLM"""
        prompt = f"""Summarize what this Terraform code does in natural language:

{code}

Summary:"""
        
        inputs = self.tokenizer(prompt, return_tensors="pt", truncation=True)
        outputs = self.model.generate(
            inputs["input_ids"],
            max_length=200,
            temperature=0.7,
            num_return_sequences=1
        )
        summary = self.tokenizer.decode(outputs[0], skip_special_tokens=True)
        return summary.replace(prompt, "").strip()

    def process_file(self, file_path):
        """Process a single Terraform file"""
        code = self.preprocess_code(file_path)
        if code:
            summary = self.generate_summary(code)
            return {
                "instruction": summary,
                "code": code,
                "source_file": file_path
            }
        return None

    def create_dataset(self, repo_dir, num_workers=4):
        """Create the full dataset"""
        tf_files = self.collect_terraform_files(repo_dir)
        dataset = []
        
        with ThreadPoolExecutor(max_workers=num_workers) as executor:
            results = executor.map(self.process_file, tf_files)
            
        for result in results:
            if result:
                dataset.append(result)
                
        return dataset

    def save_dataset(self, dataset):
        """Save the dataset to disk"""
        os.makedirs(self.output_dir, exist_ok=True)
        output_file = os.path.join(self.output_dir, "terraform_dataset.json")
        with open(output_file, 'w') as f:
            json.dump(dataset, f, indent=2)