class DatasetFilter:
    def __init__(self, min_code_length=50, max_code_length=2000):
        self.min_code_length = min_code_length
        self.max_code_length = max_code_length
    
    def filter_dataset(self, dataset):
        """Filter the dataset based on quality criteria"""
        filtered_dataset = []
        
        for item in dataset:
            if self.is_valid_pair(item):
                filtered_dataset.append(item)
                
        return filtered_dataset
    
    def is_valid_pair(self, item):
        """Check if an instruction-code pair meets quality criteria"""
        code = item["code"]
        instruction = item["instruction"]
        
        # Length checks
        if len(code) < self.min_code_length or len(code) > self.max_code_length:
            return False
            
        # Basic Terraform syntax check
        if not self.has_terraform_blocks(code):
            return False
            
        # Instruction quality check
        if len(instruction.split()) < 10:
            return False
            
        return True
    
    def has_terraform_blocks(self, code):
        """Check if code contains basic Terraform blocks"""
        common_blocks = ["resource", "variable", "provider", "data"]
        return any(block in code.lower() for block in common_blocks)