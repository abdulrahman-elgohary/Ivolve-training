output "sg-proxy-id"{
    value = aws_security_group.proxy-sg-tr.id
}

output "sg-http-id" {
    
    value = aws_security_group.http-sg-tr.id
}

output "sg-lb-tr" {
    value = aws_security_group.lb-sg-tr.id
}

output "sg-in-lb-tr" {
  value = aws_security_group.internal-lb-sg-tr.id
}