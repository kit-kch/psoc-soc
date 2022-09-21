## This script can be sourced from a Synthesis script or used as reference and copied in a flow
## It creates the default I2C,I2O,C2O and C2C groups (register to register and input/outputs)

## IMPORTANT: The synthesize script must define a variable called top_module to store the name of the top level
## To remove already existing costgroups before creating new ones, use following line before sourcing this script
#catch {delete_obj [vfind /designs/* -cost_group *]}

set noC2C true

if {$noC2C} {


    if {[llength [all_registers]] > 0} {
      set list_mod [vfind / -mode *]
      if {[llength $list_mod] >= 1} {
        foreach mode $list_mod {
          define_cost_group -name I2C_[vbasename $mode] -design $top_module
          define_cost_group -name C2O_[vbasename $mode] -design $top_module
        }
      } else {
        define_cost_group -name I2C -design $top_module
        define_cost_group -name C2O -design $top_module
      }

      foreach mode [vfind / -mode *] {
        path_group -from [all_registers] -to [all_outputs] -group C2O_[vbasename $mode] -name C2O_[vbasename $mode] -mode $mode 
        path_group -from [all_inputs]  -to [all_registers] -group I2C_[vbasename $mode] -name I2C_[vbasename $mode] -mode $mode
      }
  }

  set list_mod [vfind / -mode *]
  if {[llength $list_mod] >= 1} {
    foreach mode $list_mod {
      define_cost_group -name I2O_[vbasename $mode] -design $top_module
    }
  } else {
    define_cost_group -name I2O -design $top_module 
  }
  foreach mode [vfind / -mode *] {
    path_group -from [all_inputs]  -to [all_outputs] -group I2O_[vbasename $mode] -name I2O_[vbasename $mode] -mode $mode
  }

} else {


  if {[llength [all_registers]] > 0} {
    set list_mod [vfind / -mode *]
    if {[llength $list_mod] >= 1} {
      foreach mode $list_mod {
        define_cost_group -name I2C_[vbasename $mode] -design $top_module
        define_cost_group -name C2O_[vbasename $mode] -design $top_module
        define_cost_group -name C2C_[vbasename $mode] -design $top_module
      }
    } else {
      define_cost_group -name I2C -design $top_module
      define_cost_group -name C2O -design $top_module
      define_cost_group -name C2C -design $top_module
    }

    foreach mode [vfind / -mode *] {
      path_group -from [all_registers] -to [all_registers] -group C2C_[vbasename $mode] -name C2C_[vbasename $mode] -mode $mode
      path_group -from [all_registers] -to [all_outputs] -group C2O_[vbasename $mode] -name C2O_[vbasename $mode] -mode $mode 
      path_group -from [all_inputs]  -to [all_registers] -group I2C_[vbasename $mode] -name I2C_[vbasename $mode] -mode $mode
    }
  }

  set list_mod [vfind / -mode *]
  if {[llength $list_mod] >= 1} {
    foreach mode $list_mod {
      define_cost_group -name I2O_[vbasename $mode] -design $top_module
    }
  } else {
    define_cost_group -name I2O -design $top_module 
  }
  foreach mode [vfind / -mode *] {
    path_group -from [all_inputs]  -to [all_outputs] -group I2O_[vbasename $mode] -name I2O_[vbasename $mode] -mode $mode
  }

}
