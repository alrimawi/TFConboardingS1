# Create a VPC
resource "aws_vpc" "onboardingvpc" {
tags = {
    Name = "Onboarding VPC"
  }
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "private_subnet_az1" {
  vpc_id                  = aws_vpc.onboardingvpc.id
  availability_zone       = "us-east-2a"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet in us-east-2a"
  }
}

resource "aws_subnet" "private_subnet_az2" {
  vpc_id                  = aws_vpc.onboardingvpc.id
  availability_zone       = "us-east-2b"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet in us-east-2b"
  }
}

resource "aws_subnet" "private_subnet_az3" {
  vpc_id                  = aws_vpc.onboardingvpc.id
  availability_zone       = "us-east-2c"
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet in us-east-2c"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.onboardingvpc.id

  tags = {
    Name = "main"
  }
}


# Create the ALB
resource "aws_lb" "my_alb" {
  name               = "my-application-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.private_subnet_az1.id, aws_subnet.private_subnet_az2.id, aws_subnet.private_subnet_az3.id]
  security_groups    = [aws_security_group.alb_sg.id]
}

# Create a target group
resource "aws_lb_target_group" "my_target_group" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.onboardingvpc.id
}


# Create an Auto Scaling Group
resource "aws_launch_configuration" "example" {
  name_prefix   = "example-"
  image_id      = "ami-089c26792dcb1fbd4"  # Replace with your desired AMI
  instance_type = "t2.micro"
  security_groups = [aws_security_group.ec2_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum install -y nginx
              service nginx start
              chkconfig nginx on
              EOF
}

resource "aws_autoscaling_group" "example" {
  name                 = "example-asg"
  max_size             = 3
  min_size             = 3
  desired_capacity     = 3
  vpc_zone_identifier  = [aws_subnet.private_subnet_az1.id, aws_subnet.private_subnet_az2.id, aws_subnet.private_subnet_az3.id]
  launch_configuration = aws_launch_configuration.example.name
  target_group_arns    = [aws_lb_target_group.my_target_group.arn]

  tag {
    key                 = "Name"
    value               = "example-instance"
    propagate_at_launch = true
  }
}