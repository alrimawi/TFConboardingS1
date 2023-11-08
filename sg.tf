# Create a security group for the ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "Security group for the Application Load Balancer"
  vpc_id        = aws_vpc.onboardingvpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to the world, restrict as needed
  }
}

# Define the security group for your EC2 instances
resource "aws_security_group" "ec2_sg" {
  name_prefix   = "ec2-sg-"
  description   = "Security group for EC2 instances"
  vpc_id        = aws_vpc.onboardingvpc.id

  # Define inbound rules for your security group as needed
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}