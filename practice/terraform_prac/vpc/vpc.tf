resource "aws_vpc" "test-vpc" {
  cidr_block = "10.10.0.0/16"
  tags = {
    Name = "test-vpc"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.test-vpc.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id                  = aws_vpc.test-vpc.id
  cidr_block              = "10.10.5.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "private-subnet"
  }
}

resource "aws_internet_gateway" "test-igw" {
  vpc_id = aws_vpc.test-vpc.id
  tags = {
    Name = "test-igw"
  }
}

//Create Route table
resource "aws_route_table" "test-rt" {
  vpc_id = aws_vpc.test-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-igw.id
  }

  tags = {
    Name = "test-rt"
  }
}

//Create route table association - To associate subnet to the route table
resource "aws_route_table_association" "test-rt-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.test-rt.id

}

 module "sgs" {
    source = "../sg_eks"
    vpc_id     =     aws_vpc.test-vpc.id
 }

  module "eks" {
       source = "../eks"
       vpc_id     =     aws_vpc.test-vpc.id
       subnet_ids = [aws_subnet.public-subnet.id,aws_subnet.private-subnet.id]
       sg_ids = module.sgs.security_group_public
 }