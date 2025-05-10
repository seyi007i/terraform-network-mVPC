resource "aws_key_pair" "deployer" {
  key_name    = "terraform-key"
  public_key = file("~/.ssh/terraform-key.pub") 
}