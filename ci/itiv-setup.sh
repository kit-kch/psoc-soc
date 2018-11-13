# Source this script file on ITIV machines with /tools setup
# to setup Vivado, Cadence and QuestaSim for the fpga build.

# Setup a single license server. To set multiple servers
# call this function multiple times, one time per server.
setup_license_server ()
{
    local LICENSE_SERVERS=$1
    # Do not duplicate entries and keep old entries
    if [ -z "${LM_LICENSE_FILE}" ]; then
        export LM_LICENSE_FILE="${LICENSE_SERVERS}"
    elif [[ ${LM_LICENSE_FILE} != *"${LICENSE_SERVERS}"* ]]; then
        export LM_LICENSE_FILE="${LM_LICENSE_FILE}:${LICENSE_SERVERS}"
    fi
}

# Setup vivado
setup_vivado ()
{
    export X_VIVADO="/tools/xilinx/ISE_EDK/Vivado/2018.2"
    case $(uname -m) in
    *ia64* | x86_64)
      source ${X_VIVADO}/settings64.sh ${X_VIVADO}
      ;;
    *)
      source ${X_VIVADO}/settings32.sh ${X_VIVADO}
      ;;
    esac
}

setup_license_server "27830@ls.itiv.kit.edu"
setup_vivado
