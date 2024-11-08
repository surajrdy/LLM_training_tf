resource "aws_iam_policy_attachment" "cloudwatch_attachment" {
    name = "botmetric-policy-cloudwatch-${random_pet.p.id}"
    roles = ["${aws_iam_role.external_admin_role.name}" ]
    policy_arn = "${aws_iam_policy.cloudwatch.arn}"
}
resource "aws_iam_policy" "cloudwatch" {
    name = "botmetric-cloudwatch-${random_pet.p.id}"
    path = "/"
    policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
            {
                  "Effect": "Allow",
                  "Action": [
                        "sns:ConfirmSubscription",
                        "sns:Create*",
                        "sns:DeleteTopic",
                        "sns:Get*",
                        "sns:List*",
                        "sns:Set*",
                        "sns:Subscribe",
                        "sns:Unsubscribe"
                  ],
                  "Resource": [
                        "*"
                  ]
            },
            {
                  "Effect": "Allow",
                  "Action": [
                        "cloudwatch:Describe*",
                        "cloudwatch:Enable*",
                        "cloudwatch:Get*",
                        "cloudwatch:List*",
                        "cloudwatch:Put*"
                  ],
                  "Resource": [
                        "*"
                  ]
            }
      ]
}
EOF
}
