output "private" {
  value = aws_subnet.nextprivate.*.id
}

output "public" {
  value = aws_subnet.nextpublic.*.id
}

output "node_role" {
  value = aws_iam_role.demo.name
}

output "demo_role" {
  value = aws_iam_role.nodes.name
}