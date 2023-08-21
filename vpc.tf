resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  private_cidr = var.private_cidr
  availability_zones = var.availability_zones
  public_cidr = var.public_cidr

tags = {
  Name = vpc_nextp
 }
}

# create igw
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "igwp"
  }
}

# Create EIP
resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "eipnextp"
  }
}

# Create NAT gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Create public subnet
resource "aws_subnet" "nextpublic" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.1.0/20"

  tags = {
    Name = "nextsubpublic"
   "kubernetes.io/role/elb" = "1"
   "kubernetes.io/cluster/demo" = "owned"
  }
}

# Create private subnet
resource "aws_subnet" "nextprivate" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.1.0/20"

  tags = {
    Name = "nextsubprivate"
   "kubernetes.io/role/internal-elb" = "1"
   "kubernetes.io/cluster/demo" = "owned"
  }
}

# Create private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc1.id

  depends_on = [aws_subnet.nextprivate]

  tags = {
    Name = "private"
  }
}

# Create public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc1.id

  depends_on = [aws_subnet.nextpublic]

  tags = {
    Name = "public"
  }
}

# Create public routes
resource "aws_route" "public_internet_gateway" {

  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id

  depends_on = [aws_route_table.nextpublic]
}

# Private routes
resource "aws_route" "private_nat_gateway" {

  route_table_id         = aws_route_table.private.id
  nat_gateway_id         = aws_nat_gateway.nat.id
  destination_cidr_block = "0.0.0.0/0"

  depends_on = [aws_route_table.nextprivate]
}

# Private route association
resource "aws_route_table_association" "private" {
  count = length(var.private_cidr)

  subnet_id      = element(aws_subnet.nextprivate[*].id, count.index)
  route_table_id = aws_route_table.private.id

  depends_on = [aws_route.private_nat_gateway, aws_subnet.nextprivate]
}

# Public route association
resource "aws_route_table_association" "public" {
  count = length(var.public_cidr)

  subnet_id      = element(aws_subnet.nextpublic[*].id, count.index)
  route_table_id = aws_route_table.public.id

  depends_on = [aws_route.public_internet_gateway, aws_subnet.nextpublic]
}