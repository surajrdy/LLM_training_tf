##############################################################################################################
# RESOURCES (Random)
##############################################################################################################

resource "random_id" "random_suffix" {
  byte_length = 8
   keepers = {
    seed = "new_id_seed"
  }
}