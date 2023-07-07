output "rendered" {
  value = "${local.header}${join("\n", data.template_file.init.*.rendered)}"
}
