#!/bin/tcsh -f
#------------------------------------
# MOAB batch directives
#PBS -N frepp.atw_ocean_av_annual_subsfc_ocean.csh
#PBS -l walltime=18:00:00
#PBS -l size=1
#PBS -j oe
#PBS -o /home/Niki.Zadeh/warsaw_mom6_2017.06.12/CM4_c96L33_am4p0_OMp5_2010_ndiff_khtr200_fk30_30d_tlt_me.2017.06.12/gfdl.ncrc4-intel16-prod-openmp/scripts/analysis/frepp.atw_ocean_av_annual_subsfc_ocean.csh.0001-0004.899449407.printout
#PBS -r y
#------------------------------------
# SGE batch directives
#$ -l h_cpu=18:00:00
#$ -pe ic.postp 2
#$ -j y
#$ -o /home/Niki.Zadeh/warsaw_mom6_2017.06.12/CM4_c96L33_am4p0_OMp5_2010_ndiff_khtr200_fk30_30d_tlt_me.2017.06.12/gfdl.ncrc4-intel16-prod-openmp/scripts/analysis/frepp.atw_ocean_av_annual_subsfc_ocean.csh.0001-0004.899449407.printout
#$ -r y
#------------------------------------
#
#NAME
#   frepp.atw_ocean_av_annual_subsfc_ocean.csh
#
#SYNOPSIS
#   Use frepp to create figures and statistics from oceanic data.
#
#DESCRIPTION
#   Creates figures and statistics from oceanic data.  This script is just
#   a simple wrapper around a more general workhorse script.  Here we eliminate
#   several options of that script by instead relying on frepp to set their
#   values.
#
#   If any arguments are supplied on the command line, those will replace the
#   original frepp-supplied arguments which are stored in ARGU.
#
#   For details: $work_script -h
#
#SOURCE DATA
#   pp/ocean/av/annual_*
#
#OUTPUT
#   Creates figures, statistics, and data in
#      $out_dir/atw_ocean_av_annual/subsfc_ocean/
#
#AUTHOR
#   Andrew Wittenberg
#
#SAMPLE FREPP USAGE
#
# <component type="ocean">
#    <timeAverage source="annual" interval="20yr">
#       <analysis script="script_name options"/>
#    </timeSeries>
# </component>
#
# See also: http://www.gfdl.noaa.gov/fms/fre/#analysis
#
# atw 5dec2014

set name = `basename $0`

# set paths to tools
source /home/atw/.atw_env_vars
set work_script = $ATW_FRE_ANALYSIS/atw/code/ocean_av_annual/subsfc_ocean/csh/subsfc_ocean.csh
set echo2 = $ATW_UTIL/echo2

set echo
# ============== VARIABLES SET BY FREPP =============
# original arguments passed to this script when it was created by frepp
set argu
# path to NetCDF files postprocessed by frepp, as specified in XML
set in_data_dir
# input data file[s], without any path prefix;
# currently only used by timeAverage diagnostics
set in_data_file
# experiment name (as appears in output directory names)
set descriptor
# final output directory for diagnostics generated by this script
set out_dir
# working directory -- do whatever you want in here
# we may have to create this (use "mkdir -p" to be sure)
# and then clean up at end
set WORKDIR
# history directory where the original "*.nc.cpio" files are found
set hist_dir

# actual start/end years of diagnostics (start_year & end_year in XML)
set yr1
set yr2
# alternate way to specify a single year (instead of yr1==yr2)
set specify_year

# Data years, only used in scripts using time series as input, to
# generate a Ferret descriptor file from consecutive NetCDF chunks.
# start year of first chunk
set databegyr
# end year of last chunk
set dataendyr
# chunk length (an integer number), as specified in XML
set datachunk
# first year of integration (4-digits, e.g. the year of initial condition)
set MODEL_start_yr
# a string: "monthly" or "annual" for timeseries data
set freq

# a string to indicate the mode: "batch" or "interactive"
set mode
# Specify MOM version; "om2" or "om3" because some files depend on mom's grid
set mom_version
# full path to the grid specification file, which contains the land/sea mask
set gridspecfile
# atmospheric land mask file
set staticfile

# the following variables are used for model-model comparisons only
set yr1_2
set yr2_2
set descriptor_2
set in_data_dir_2
set databegyr_2
set dataendyr_2
set datachunk_2
set staticfile_2

# ============== END OF VARIABLES SET BY FREPP =============

# If any arguments were supplied on the command line, then those
# will replace the original frepp-supplied arguments.
if ($#argv) set argu = ($argv:q)

# =============== START BODY OF SCRIPT ==============

if ($yr1_2 == "") then
   set ref_opt
else
   set ref_opt = (-r gfdl_model,$yr1_2,$yr2_2,$descriptor_2,$in_data_dir_2,$databegyr_2,$dataendyr_2,$datachunk_2)
endif


#$work_script -o $out_dir $ref_opt \
#   -m gfdl_model,$yr1,$yr2,$descriptor,$in_data_dir,$databegyr,$dataendyr,$datachunk \
#   $argu:q || goto err


# =============== START BODY OF SCRIPT ==============
set pregrid_opt   = "-g g1x1,fill,nolabel,x=0:360:1,y=-90:90:1"
set shared_opt    = "-V2 -P ps.gz -s" 
set x_global      = "-d x,25,385,60,2"
set y_tropics     = "-d y,-20,20,10,4"
set y_subpolar    = "-d y,-60,60,20,1"
set y_global      = "-d y,-90,90,20,1"
set default_region = "-N tropics $x_global $y_tropics"
set sigma_vars        = "sigma0_diff0_eq,dsigma0dz_eq,dsigma0dz_zmaxloc"
set temp_yslice_vars  = "temp_165e,temp_170w,temp_140w,temp_110w"
set salt_yslice_vars  = "salt_165e,salt_170w,salt_140w,salt_110w"
set dtdz_vars         = "dtdz_165e,dtdz_170w,dtdz_140w,dtdz_110w,dtdz_zmaxloc"



set argu_test1 = "$shared_opt $pregrid_opt -n -r oisst_v2 -A globe -N subpolar $y_subpolar plot_clim"
$work_script -o $out_dir $ref_opt \
   -m gfdl_model,$yr1,$yr2,$descriptor,$in_data_dir,$databegyr,$dataendyr,$datachunk \
   $argu $argu_test1 || goto err

set argu_test2 = "$shared_opt $pregrid_opt -n -r oisst_v2 $default_region plot_clim"
$work_script -o $out_dir $ref_opt \
   -m gfdl_model,$yr1,$yr2,$descriptor,$in_data_dir,$databegyr,$dataendyr,$datachunk \
   $argu $argu_test2 || goto err

set argu_test3 = "$shared_opt $pregrid_opt -n -r oscar_v2009 -v u_top30m $default_region plot_clim"
$work_script -o $out_dir $ref_opt \
   -m gfdl_model,$yr1,$yr2,$descriptor,$in_data_dir,$databegyr,$dataendyr,$datachunk \
   $argu $argu_test3 || goto err

set argu_test5 = "$shared_opt $pregrid_opt -n -r woa13 -v sst,sst_m_t50,d20,d15,ild_0p5,ild_1,mld_0p125,temp_diff0_eq,temp_top50m,temp_xav,temp_zav,temp_eq,$temp_yslice_vars,dtdx_surf,dtdx_eq,dtdy_surf,dtdz_eq,$dtdz_vars,dtdz_xav,dtdz_zmax,sss,sss_m_s50,salt_eq,$salt_yslice_vars,sigma0_eq,$sigma_vars,dsigma0dz_zmax $default_region plot_clim"
$work_script -o $out_dir $ref_opt \
   -m gfdl_model,$yr1,$yr2,$descriptor,$in_data_dir,$databegyr,$dataendyr,$datachunk \
   $argu $argu_test5 || goto err

set argu_test6 = "$shared_opt $pregrid_opt -n -r oras4_orca1_era_interim -v sst,sst_m_t50,d20,d15,ild_0p5,ild_1,mld_0p125,temp_eq,temp_diff0_eq,temp_top50m,temp_xav,temp_zav,$temp_yslice_vars,dtdx_surf,dtdx_eq,dtdx_xav,dtdy_surf,dtdz_eq,dtdz_xav,$dtdz_vars,dtdz_zmax,sss,sss_m_s50,salt_eq,$salt_yslice_vars,sigma0_eq,$sigma_vars,dsigma0dz_zmax,u_surf,u_top30m,u_eq,u_xav,u_zav,u_165e,u_170w,u_140w,u_110w,v_surf,v_top30m,v_eq,v_xav,v_zav,v_165e,v_170w,v_140w,v_110w,tadv_x_eq,tadv_x_xav,tadv_x_top50m,tadv_x_zav,tadv_y_eq,tadv_y_xav,tadv_y_top50m,tadv_y_zav $default_region plot_clim"
$work_script -o $out_dir $ref_opt \
   -m gfdl_model,$yr1,$yr2,$descriptor,$in_data_dir,$databegyr,$dataendyr,$datachunk \
   $argu $argu_test6 || goto err

# ================ END BODY OF SCRIPT ===============
unset echo

exit 0

err:
   $echo2 "$name aborted on error."
   exit 1