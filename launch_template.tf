// gives a random id so we can set unique identifiers for resources
resource "random_id" "id" {
	  byte_length = 8
}

resource "aws_launch_template" "ec2_lt_public" {
  name_prefix   = "LT_${random_id.id.hex}"
  description   = "LC for EC2 instances"
  image_id      = "ami-07761f3ae34c4478d"
  instance_type = "t2.micro"
  key_name      = "mykeypair"
  // you need to use base644encode to run user_data. Use command base64 -w 0 ec2_bash_script.sh
  user_data = "IyEgL2Jpbi9iYXNoCiMgbmVlZHMgdG8gY29weSBwYXN0ZWQgZXhhY3RseSBsaWtlIHRoaXMsIGZvciBzb21lIHJlYXNvbiB0aGUgd2dldCBuZWVkcyB0byBiZSBlbnRlcmVkIHRoaXMgZXhhY3Qgd2F5CgpzdWRvIHl1bSB1cGRhdGUgLXkKCnN1ZG8gd2dldCAtTyAvZXRjL3l1bS5yZXBvcy5kL2plbmtpbnMucmVwbyBcCiAgICBodHRwczovL3BrZy5qZW5raW5zLmlvL3JlZGhhdC1zdGFibGUvamVua2lucy5yZXBvCgpzdWRvIHJwbSAtLWltcG9ydCBodHRwczovL3BrZy5qZW5raW5zLmlvL3JlZGhhdC1zdGFibGUvamVua2lucy5pby0yMDIzLmtleQoKc3VkbyB5dW0gdXBncmFkZQoKc3VkbyB5dW0gaW5zdGFsbCBqYXZhLTE3LWFtYXpvbi1jb3JyZXR0by1oZWFkbGVzcyAteQoKc3VkbyB5dW0gaW5zdGFsbCBqZW5raW5zIC15CgpzdWRvIHN5c3RlbWN0bCBlbmFibGUgamVua2lucwoKc3VkbyBzeXN0ZW1jdGwgc3RhcnQgamVua2lucwoKc3VkbyBhbWF6b24tbGludXgtZXh0cmFzIGluc3RhbGwgZG9ja2VyIC15CgpzdWRvIHNlcnZpY2UgZG9ja2VyIHN0YXJ0CgojIG5lZWQgdG8gYWRkIGdyb3VwIGZvciBkb2NrZXIgdG8gZ28gYXJvdW5kIHBlcm1pc3Npb24sIHRoZSBlYzItdXNlciB3b3VsZCBiZSBjaGFuZ2VkIGRlcGVuZGluZyBvbiB5b3VyIGZsYXZvciBhbWkKCnN1ZG8gZ3JvdXBhZGQgZG9ja2VyCgpzdWRvIHVzZXJtb2QgLWEgLUcgZG9ja2VyIGVjMi11c2VyCgpuZXdncnAgZG9ja2VyCgpzdWRvIGRvY2tlciBwdWxsIHl1bGVldGVhL3B5dGhvbi1mbGFzawoKIyBpbnN0YWxsIHBpcCBhbmQgZmxhc2sgZGVwZW5kYW5jaWVzCgojICNJbnN0YWxsIHRoZSBQeXRob24gZGV2ZWxvcGVyIHBhY2thZ2UgdG8gZ2V0IHRoZSBoZWFkZXJzIGFuZCBsaWJyYXJpZXMgcmVxdWlyZWQgdG8gY29tcGlsZSBleHRlbnNpb25zIGFuZCBpbnN0YWxsIHBpcDoKIyBzdWRvIHl1bSBpbnN0YWxsIHB5dGhvbjMtZGV2ZWwgLXkKCiMgc3VkbyBjdXJsIC1PIGh0dHBzOi8vYm9vdHN0cmFwLnB5cGEuaW8vZ2V0LXBpcC5weQoKIyBzdWRvIHl1bSBpbnN0YWxsIHBpcDMKCiMgcGlwMyBpbnN0YWxsIEZsYXNr"

  depends_on = [aws_vpc.my_vpc]

  network_interfaces {
    associate_public_ip_address = true
    // sg's need to be assigned here to use public ip addresses
    security_groups = [ aws_security_group.my_terraform_sg.id ]
  }

  placement {
    availability_zone = "us-east-1"
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
        // appending a unique identifier method to the name
      Name = "TerraformServer-${random_id.id.hex}"
    }
  }

}
