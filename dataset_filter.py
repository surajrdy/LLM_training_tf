import re

class DatasetFilter:
    def __init__(self, min_code_length=50, max_code_length=5000, min_instruction_length=20):
        self.min_code_length = min_code_length
        self.max_code_length = max_code_length
        self.min_instruction_length = min_instruction_length

    def filter_dataset(self, dataset):
        """Filter the dataset based on quality criteria."""
        filtered_dataset = []

        for item in dataset:
            if self.is_valid_pair(item):
                filtered_dataset.append(item)

        return filtered_dataset

    def is_valid_pair(self, item):
        """Check if an instruction-code pair meets the quality criteria."""
        code = item["code"]
        instruction = item["instruction"]

        # Length checks
        if len(code) < self.min_code_length or len(code) > self.max_code_length:
            return False

        # Basic Terraform syntax check
        if not self.has_terraform_blocks(code):
            return False

        # Instruction quality check
        if len(instruction.split()) < self.min_instruction_length:
            return False

        # Check for potential sensitive information
        if self.contains_sensitive_info(code):
            return False

        return True

    def has_terraform_blocks(self, code):
        """Check if the code contains basic Terraform blocks."""
        common_blocks = ["resource", "variable", "provider", "data", "module", "output"]
        return any(re.search(r'\b' + block + r'\b', code) for block in common_blocks)

    def contains_sensitive_info(self, code):
        """Check if the code contains potential sensitive information."""
        patterns = [
            r'aws_access_key_id', r'aws_secret_access_key',
            r'password', r'secret', r'private_key', r'ssl_cert', r'api_key'
        ]
        return any(re.search(pattern, code, re.IGNORECASE) for pattern in patterns)
