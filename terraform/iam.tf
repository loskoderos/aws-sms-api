resource "aws_iam_role" "smsapi" {
  name = "${var.project}-lambda"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
  EOF
}

// Needed for logging to CloudWatch Logs.
resource "aws_iam_role_policy_attachment" "logs" {
  role = "${aws_iam_role.smsapi.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "sns" {
  name = "${var.project}-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "SNS:Publish"
      ],
      "Resource": "*"
    }
  ]
}
  EOF
}

resource "aws_iam_role_policy_attachment" "sns" {
  role = "${aws_iam_role.smsapi.name}"
  policy_arn = "${aws_iam_policy.sns.arn}"
}
