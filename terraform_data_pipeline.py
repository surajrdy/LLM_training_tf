import os
import glob
import json
from concurrent.futures import ThreadPoolExecutor
from anthropic import Anthropic, HUMAN_PROMPT, AI_PROMPT

class TerraformDataPipeline:
    def __init__(self, api_key, output_dir):
        self.anthropic = Anthropic(api_key=api_key)
        self.output_dir = output_dir

    def collect_terraform_files(self, repo_dir):
        """Collect all Terraform files from the repository directory."""
        tf_files = []
        for ext in ['*.tf', '*.tfvars']:
            tf_files.extend(glob.glob(f"{repo_dir}/**/{ext}", recursive=True))
        return tf_files

    def preprocess_code(self, code):
        """Clean Terraform code by removing comments and empty lines."""
        lines = code.split('\n')
        cleaned_lines = []
        in_multiline_comment = False
        for line in lines:
            line_strip = line.strip()
            # Handle multiline comments
            if line_strip.startswith('/*'):
                in_multiline_comment = True
                continue
            if line_strip.endswith('*/'):
                in_multiline_comment = False
                continue
            if in_multiline_comment:
                continue
            # Handle single-line comments and empty lines
            if line_strip.startswith('#') or line_strip.startswith('//') or not line_strip:
                continue
            cleaned_lines.append(line)
        cleaned_code = '\n'.join(cleaned_lines)
        return cleaned_code

    def generate_summary(self, code):
        """Generate a natural language summary of Terraform code using Claude."""
        prompt = f"""{HUMAN_PROMPT} Summarize the following Terraform code in natural language, focusing on the resources being provisioned and their configurations:

{code}

{AI_PROMPT}"""

        response = self.anthropic.completions.create(
            model="claude-v1",
            prompt=prompt,
            max_tokens_to_sample=512,
            temperature=0.7,
            stop_sequences=[HUMAN_PROMPT]
        )
        summary = response.completion.strip()
        return summary

    def process_file(self, file_path):
        """Process a single Terraform file to generate an instruction-code pair."""
        try:
            with open(file_path, 'r') as f:
                code = f.read()
            code = self.preprocess_code(code)
            if code:
                summary = self.generate_summary(code)
                return {
                    "instruction": summary,
                    "code": code,
                    "source_file": file_path
                }
        except Exception as e:
            print(f"Error processing {file_path}: {e}")
        return None

    def create_dataset(self, repo_dir, num_workers=4):
        """Create the dataset by processing all collected Terraform files."""
        tf_files = self.collect_terraform_files(repo_dir)
        dataset = []

        with ThreadPoolExecutor(max_workers=num_workers) as executor:
            results = executor.map(self.process_file, tf_files)

        for result in results:
            if result:
                dataset.append(result)

        return dataset

    def save_dataset(self, dataset):
        """Save the generated dataset to a JSON file."""
        os.makedirs(self.output_dir, exist_ok=True)
        output_file = os.path.join(self.output_dir, "terraform_dataset.json")
        with open(output_file, 'w') as f:
            json.dump(dataset, f, indent=2)
