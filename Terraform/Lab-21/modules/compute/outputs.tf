output "proxy-instances-id" {
  value = aws_instance.proxy-tr-instances.*.id
}

output "http-instnces" {
  value = aws_instance.http-instances.*.id
}
