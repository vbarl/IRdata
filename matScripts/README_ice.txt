------READ-ME file for the ice particle database------

1. The directories (./Data_0.2_15.25/) and (./Data_16.4_99.0/) contain 
single-scattering properties of ice particles assuming various shapes 
and particle surface roughness from 0.2 um to 15.25 um and from 16.4 um
to 99.0 um, respectively. The nine habits are: 

   1). hexagonal column            (folder name: single_column)
   2). plate                       (folder name: plate)
   3). hollow column               (folder name: HC)
   4). droxtal                     (folder name: droxtal)
   5). hollow bullet rossette      (folder name: HBR)
   6). solid bullet rossette       (folder name: SBR)
   7). 8-element column aggregate  (folder name: 8_columns)
   8). 5-element plate aggregate   (folder name: 5_plates)
   9). 10-element plate aggregate  (folder name: 10_plates).

2. Each type of shape has three degrees of roughness: 

   1). smooth           (folder name: Rough000)
   2). moderately rough (folder name: Rough003)
   3). severely rough   (folder name: Rough050).

3. Wavelength range: 
   0.2~15.25 um, 396 wavelengths; 
   16.4~99.0 um, 49 wavelengths.

4. Paricle size range: 
   2.0~10000 um, 189 sizes. 

5. In each particle shape and roughness case, one "isca.dat" file is provided. 
Its format is (74844 rows, 7 columns) or (9261 rows, 7 columns). 
The seven columns are: 

   1). wavelength (um) 
   2). maximum dimension of the particle(um)
   3). volume of particle  (um^3) 
   4). projected area (um^2)
   5). extinction efficiency
   6). single-scattering albedo 
   7). asymmetry factor.

The number of lines is 396 (or 49) wavelengths times 189 
particle sizes (size loops first). 

6. The non-zero phase matrix elements are stored seperately.
   P12, P22, P33, P34, and P44 are normalized by P11.

   1). P11 (folder name: P11.dat)
   2). P12/P11 (folder name: P12.dat)
   3). P22/P11 (folder name: P22.dat)
   4). P33/P11 (folder name: P33.dat)
   5). P43/P11 (folder name: P43.dat)
   6). P44/P11 (folder name: P44.dat)

The number of lines is 396 (or 49) wavelengths times 189 
particle sizes (size loops first), and adding one line at the beginning
showing the scattering angles (498 scattering angles in 0~180 degrees).
 
7. Whole steradian integral of P11 is 4*pi:
   
      pi     2*pi
   int    int     P11 d(zenith angle)d(azimuth angle)=4*pi
      0      0


Reference:

   1). Yang, P., L. Bi, B.A. Baum, K.-N. Liou, G.W. Kattawar, M.I. Mishchenko, 
   and B. Cole, 2013: Spectrally consistent scattering, absorption, and 
   polarization properties of atmospheric ice crystals at wavelengths from 
   0.2 µm to 100µm, J. Atmos. Sci., 70, 330-347.
   
   2). Bi, L., and P. Yang, 2017: Improved ice particle optical property 
   simulations in the ultraviolet to far-infrared regime, 
   J. Quant. Spectrosc. Radiat. Transfer, 189, 228-237.
