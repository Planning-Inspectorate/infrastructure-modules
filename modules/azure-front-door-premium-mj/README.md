# README

## Functions

### coalesce

coalesce takes any number of arguments and returns the first one that isn't null or an empty string.

All of the arguments must be of the same type. Terraform will try to convert mismatched arguments to the most general of the types that all arguments can convert to, or return an error if the types are incompatible. The result type is the same as the type of all of the arguments.

### flatten

flatten takes a list and replaces any elements that are lists with a flattened sequence of the list contents.

## Notes

- [ ] Can we stand it up with no endpoints, origins, origin groups...
- Do routes later.
- Maps vs Lists <https://sokolovtech.com/terraform/94-lists-vs-maps-in-terraform-variables>
- Could make RGs and regions a module on their own - claranet repos do this.
