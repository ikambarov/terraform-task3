data "aws_ami" "centos7_ami" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["CentOS-7-2111-20220825_1.x86_64*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_template" "task_lt" {
  name          = "task_lt"
  key_name      = "bastion-key"
  image_id      = data.aws_ami.centos7_ami.id
  instance_type = "t2.micro"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.allow_ssh.id, aws_security_group.allow_http.id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = var.common_tags
  }

  user_data = filebase64("user_data.sh")
}

resource "aws_autoscaling_group" "task_asg" {
  name                      = "task_asg"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  vpc_zone_identifier       = [aws_subnet.subnet1.id, aws_subnet.subnet2.id, aws_subnet.subnet3.id]

  launch_template {
    id      = aws_launch_template.task_lt.id
    version = aws_launch_template.task_lt.latest_version
  }

  target_group_arns = [aws_lb_target_group.task_tg.arn]

  tag {
    key                 = "Environment"
    value               = "Test"
    propagate_at_launch = true
  }

  tag {
    key                 = "Team"
    value               = "DevOps"
    propagate_at_launch = true
  }

  tag {
    key                 = "Created_by"
    value               = "Islam_Kambarov"
    propagate_at_launch = true
  }
}
