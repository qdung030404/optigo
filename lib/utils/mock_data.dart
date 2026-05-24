import 'package:optigo/models/trip_model.dart';

class MockData {
  static List<TripModel> getMockTrips() {
    return [
      // TripModel(
      //   id: '1',
      //   driverId: 'd1',
      //   originName: 'Bình Dương',
      //   destinationName: 'Vũng tàu',
      //   originLat: 10.87099,
      //   originLng: 106.75987,
      //   destinationLat: 10.34608,
      //   destinationLng: 107.08412,
      //   routePolyline: r'cgjaAkprjSUGwBc@mAi@c@QIJKAqCaBo@o@w@q@c@[CCOGECu@[ME@EhBqIlAkFlC{KJe@lCaLpCsLJe@vAmGDQrE}RfDcOv@oDlAoFtAoGNw@VgBXaDLoDLqIHiG?M?_@BeA@_@@w@HyDF}@LyA^_CJg@`@yAZ{@n@yAv@wAr@gALCLGn@_@f@W\OLCNELCXGVCFAXEJANAB?L?L?N@l@F\BT@pBNZBTB\FjARTDPFHBFB@?RJRJNHLJRNNPx@t@x@zAxNlY\Oj@YT@NG~EgC^K~@g@z@e@l@g@@ILSVm@Le@b@cCbA}FHOLu@r@aEAM^yBfAkG\gBXu@HOn@eA^c@JGxByBBMdBkB~BcCp@o@RKrD{Df@k@rCyCBKDIvAyAzDkExD{DrByBRInCwCt@w@DONQjAoArE_FNKHAf@k@vA{AFQlDuDHILCTW|@aADMnAuAJILELMdAkA@GBGzC_Db@[PKFBH@F?H?HAFABAz@n@nAhAx@v@LF|CrCFJj@d@TFrA`AvEhDDHb@Xf@ZJBzAz@VNlBfALHHJ|@h@v@d@L@nBhAfCxAr@d@TVPLl@b@zArAf@h@^^HBf@f@r@bAZf@dDbFX`@@H^h@JPxAtBBDpBzC~ErHBLXb@PVl@~@HD|CxEBLfA~AHDxCrEjAhBJXRX\h@RZFBjDjFBH^j@NVXd@RNvCpELNX^TPTLr@PX@X?XEdBc@vAYrEc@|@K~LaArF[zCKLAb@?tDFn@?hCAtDChBE~DAjSOb@?BDDDFBFBFBF?H?F?FAFCDCDCDEn@Al@AJ?fHG'
      //                  r'lNEZ?lFCbCCnWU`D@~A?`BAFCN?xCEJODQ?OEMIM[@{D@OIMIk@OYQOSO]Ea@AsA?]A[AWEUK[OYa@g@eDeD[_@MSYe@Uk@Kc@Kq@Cg@?s@HwAR}BTqCPuCNmCB[X{DJsB?[`B{QvFal@~Dub@jC}W^gDp@mGb@eEv@yGFg@\mCfHej@nAiKxAyMhBiN`@gDv@wGJy@`@wD`@qET}C\iGFaBLwEDuDHgBDqAA_FIeCCq@?o@GkEI_Fc@qZa@eYAu@qAmgAAeHBsRGqKIoJAcIFkFFuCReFZcF\oEFm@rBwRtCmWb@sDp@sF|@yGlAoHx@_E|AuGbAsD~AsFzBeH`HmSrBsGtCqIL_@zAqE`DmJhC}HxDgLnAuDpMk`@pBqG~AkFxAgF|BwIn@qC`D{NbAkFzC_QdCeNlDqSvEiWb@_DLoAFKf@iCVuAd@qDLqAJcBN}CDu@F{CHiDDm@Fa@JWN]Te@`Ac@FAnEs@rCa@n@IRE~AWvBe@vBo@bC_Al@UbCmAxEiCrBiAzDsBbB_AxA{@h@_@d@a@bBiBn@s@~CqD|HeJj@q@~AkBv@}@tAwAvAoAfHsFjDkCzRkOtL{ItJmHlEgDh@a@dAy@xLgJzBeBjBaBx@_A|@cApDwE~@sAb@s@r@kAtAsCfAsCnAoEfAaEbAuDl@uBz@aCXo@tBgFp@wAp@gAt@aAx@_AjAeAfF{DrDmCp@k@HInDyC~@w@hAaAbAu@vLaHv@_@~@_@hDmA|@[jDgA`Bo@dAi@z@g@`As@pC{B~DgDxAcA|AcAdLaHpDwBxG_Ef'
      //                  r'BeAdBeAjDuB~BwA`@WxCiB~CkBxA{@hF}C`FwCvG_E~a@_WnEkC~BuAlBkAZQxCgBvBoAfKkG~LqH^UvA{@r@c@hDsBt@e@dLaHVOd@Wb@Y|LqHnCcBfC}AfFaD`CwAbCwAt@c@n@[`A]dC_AXKdDmAv@YZMRI|EaB`@MVIXIf@G~@AHFFBHDJDJBJ@J?L@JAJAJCJEJEFEHEFGDEFIDIDIBK@K@K@I?I\c@n@i@hAe@RIHE`A]dBm@rAg@jFkBfC}@^MpG}Bx@YhG{BrDuApBs@z@]zPqGbHiC|OyF@?vn@oTXKjb@gOtX{JtKyDfMqErTcIfDkAh@SlB_Aj@[~FmDvCiBfC_BfKcH`@YlAs@jB}@|HyCp@UpA_@vA_@lCi@p@Kz@MhCa@vHmAzCa@bAGj@EfCClE?~HB`@@|@BjAJbCb@jBZnA^dFrAzJfCrEjAxAZPDlCPxABlB?fAArGEvEC|CATAhA?fA?V?fD@xBBzFRbCJx@?xBC`CGz@GPAjG]jReAzDG`A@X?dPRvBD|BDf@@vAEnCIjK[tRk@fCIxJ_@dHe@`Ig@xEYtAIdF]rAQn@IrCu@vAm@|BeAlDgB|EiChAq@dB{AfAmAV_@v@qAlA{B`AmBh@cATc@z@uAPSz@cAp@o@~AkAv@e@xAo@`DwAdBq@|@[t@SvA[dAOpG}@l@MtAa@dBq@|Aw@xBqAfKgGTObGmDrAaA|BgBjCuBzCsBXUtBgAz@_@tBs@xBm@vAWVEdBUnAKhBOrF_@vCYbBW~Be@pD{@rA[zD}@fDy@zAc@~Ao@`'
      //                  r'Bw@bBaA~@s@tAkAf@i@p@s@jC_D~AqB~D}EnBoBnIsH`A{@XSd@YdAe@nAa@v@O^GrBMxBEfEI|BIjAIpAQ~@QdA[rD{AbAc@lD}A|Aq@~As@`B}@|DkCjDcCtCsB\WXUhAy@xCsBROjEwCNMj@_@h@a@PMn@c@jFwDrBkAjAg@~CoArMcFrAg@hDgAtBe@jB]jB]|Dw@dFaAx@Sx@Un@Up@[f@[|@s@n@q@r@_A|@gBh@oBn@qCjBkIz@gDvAyFF[xDgQZyAfBeIZqBNuBIy^EgPEeHC{@SwBu@yEsA}Hy@_FkAuGWiBSkCKeD?_@@cAFqBJoB@MVcEJaC@aDEmBKmBU_Cy@uIKiBKyC@sB^mKt@kQt@sQHgCGoCGcA_@sD[yCOmBCeAKmDEqAa@kF]qEeA_MKoAGqAAoBBy@LuAZeCdAyGXaBj@kBTm@t@uA`@q@^m@pBeCxFuGvDsEvFyGfFkGjBuCb@w@xBsE|@iBzLyWfCqFfDeHZk@j@o@H?HAHCFCFEDGDEDGBI@I@G?I?GAEAEACn@s@v@o@r@c@t@_@~@YtAYl@KfBIl@?fBJ^D~@R~@ZbB|@rAr@hDlBfXrOrUzN`Aj@z@\|@Vn@JTDlALp@BfBCx@E~ScBhFs@|Hy@dJs@`CQrBQjBYRCn@OjFqAxEmAjA[rD}@rBi@xFyAlEgArEkA~HkB|Cq@REx@Q|AYzBUnAExB@jAFjBPfBZvA\bA^v@Zz@b@v@d@f@\t@l@bA~@bBvBj@|@z@bB~Rvb@z@hBv@rA`@l@n@v@z@z@p@j@pA~@`@R'
      //                  r'ZPbAb@zBr@zElAbSfFhG~AnB`@`@FTDhBRrEZx@FnAHlEVnEZzCRfAF`AHbDPn@DpHNZBpBLd@DvDZ`CP`N|@lF\tIj@|ObA|@Hl@Px@\@?BHBHFHFFFFHFHDJBJBJ?J@HAJAHAHCHEHEFGFG@CBCBGBId@Ch@?vBLb@B~Gb@nF\nBLdPbAlEXxAJ~APjBb@l@TnAj@jAp@t@h@z@z@n@t@t@nAhBpDrIlQvHvOfEpIjBnD~FdLnKrS`CvE`IlOnAtBNTbDbFzSf[vEdHd@r@^j@tNjTnBtCf@`A^x@`@jAThAXpBbCzQRdB\dCn@pENz@Pt@Z~@j@pA`@r@|BtCzKlKpIfI~P`Pbe@vb@vGlGhFhFfBdBFJJZ?@?@?D@FBDBBBBDBDBD@D?F?D?BAV@VFxD|A\LfJpD^PjCdA|CpA^NjBv@bCbA|@\|HbDfEfB`Ab@\Th@z@?L@L?D@HBLDJDLFJ@TA^EXOZW\s@hA_@h@eEjG_CnDkBlCoAhBQRQVmAfBC?C?C?A?C@C@C@ABCB?BAB?@?B@B?@@B{AxBwCdEE?G?E@E@EBCBCBCDADAD?D?D@D@DBDBBBBBBD@D@D?D?FABADAhAvBR\l@hAR^r@rAxAnCT`@HPT^|@`BVf@DHT`@HN\n@JRT^fAtBXd@\l@NZt@vAVf@NZz@~Ax@SNGd@MlA[pA[vA]~@UTGYeA',
      //   price: 250000,
      //   availableSeats: 4,
      //   departureTime: DateTime.now().add(const Duration(days: 2)),
      //   status: 'open',
      // ),
      TripModel(
        id: '5',
        driverId: 'd5',
        originName: 'Bình Dương',
        destinationName: 'Vũng tàu',
        originLat: 10.980297,
        originLng: 106.666834,
        destinationLat: 10.34608,
        destinationLng: 107.08412,
        routePolyline: r'u~laA__wjSwC~Bi@`@wAfAUTUd@EhAJ`CPjDg@p@mAfAQLq@b@a@PeAZgA\cAZy@ZYmAUmAu@mEEUq@eEs@cEg@yCKo@s@kEEc@?eCAaAB_CAoAAUQwAESIe@U{@i@kAeAeCi@mAa@y@qAmCYe@]i@c@e@w@k@qAw@gAa@o@So@O_FcAgHuAkAWkB_@cEy@mFgAqCm@qB_@WGkHyARgAXuAh@oC`AcFf@_C`A{EBMl@oCz@iERk@Va@LQZ]PO^W`Au@\_@Xa@PWHYFa@Dy@@o@@{ABaC@sB@}ADuFBqB?UHy@F]d@sCDWp@{DTyAl@_DbAaFLk@ZoCFk@JkBDkA@e@?aAEeAU{BQkAe@sEOkA?GSeCC]AyABwCDcEDK@O?[?qB?WAUAu@Ak@QeEk@iR?SBYFa@Lm@Jg@Le@Ty@Lg@x@yEPgABW@cAAWCQaAcECMAOHs@?QCWo@oCCM@KeAgEgD{Ma@wAqD{MeDgMqCoK_@yAOo@OmAEc@QcAEWSy@k@}BqAsEa@qAEKs@mBu@}A{@yAkBsCeAyAa@i@Ze@FGLMFCRKlCcAzBy@l@Wh@Yf@Yn@i@`@_@b@i@JOPU\m@tB_EzAuC~CeG~@gBPYh@cAzFuKxDiHd@}@l@iAzA{C`@y@tImRb@eAPk@Nm@Nu@J_ADm@DqABkCBeDF{G@gBDsI?}A@cA@wCAeAGwAGsAMuAWyBc@qDUeB[}AWgA}@_Dy@kCyA}E_@qAi@gBk@kBe@}AOg@_@mB]qBaA_HUmBKsAEw@Ey@I{BUcICm@a@qMG_BfAwAzAMr@Ir@'
                        r'Ov@Up@U\Qr@a@l@a@`@YRQ^a@b@m@rAuBx@kAz@_AlBaBvA}@jAo@pB_AnJiE|GaDbAo@b@[z@w@hAmAj@q@bA{AzAuCfH_NR[~AsBV]x@_AzC}ClBgBvE_ExAqAr@o@bD{CvBmBhBoAtBgAhAi@~MkEpAc@tCiAXQ`Am@`As@fAaAV[r@y@`@q@`AiBP[Vs@To@b@aBJc@V{@@IHWlEkPTu@z@uCRi@`@}@\k@`AwAp@y@fEcErIaI|@s@hAw@|A}@~DmBl@[tFmCb@St@_@~EqB`Ac@rDkBnEaCnAc@fCu@lLuCpEgAn@QtCu@pBc@rDu@xASlAM`BQ~Eg@~Ec@~BKxCEpB@vEP|ERtA@~BId@ETChAOtA[bCw@TIh@WTMhBiAfA}@h@e@^]hBaBj@g@f@e@v@s@tBcB`@]`BgA|A{@tCqAJElIqDjBw@j@UzKuEjAg@|BaAr@[hEiBpKmEx@_@jF}BnAi@bIiDd@ShEiBzCqAdDsA|Bw@fBg@xA[vKuBvBa@`KoBlOyCdDq@xA]v@Sv@UdD_AtCaAxCaAns@_Vf@QbO_FzG{BxJaDrAc@d@OlN_ElP}EpNcExGmB~DkAb@M~Ae@nGiBlCs@hAUj@Iv@MxAOnAK|@Ed@A|DApFBfNNhDB`IFn@@v@Ah@CTCnAOjAQpMqCrDu@NCNAv@AVFF?n@@J?TCD?NCHATGPGTMXQ`Ac@FAnEs@rCa@n@IRE~AWvBe@vBo@bC_Al@UbCmAxEiCrBiAzDsBbB_AxA{@h@_@d@a@bBiBn@s@~CqD|HeJj@q@~AkB'
                        r'v@}@tAwAvAoAfHsFjDkCzRkOtL{ItJmHlEgDh@a@dAy@xLgJzBeBjBaBx@_A|@cApDwE~@sAb@s@r@kAtAsCfAsCnAoEfAaEbAuDl@uBz@aCXo@tBgFp@wAp@gAt@aAx@_AjAeAfF{DrDmCp@k@HInDyC~@w@hAaAbAu@vLaHv@_@~@_@hDmA|@[jDgA`Bo@dAi@z@g@`As@pC{B~DgDxAcA|AcAdLaHpDwBxG_EfBeAdBeAjDuB~BwA`@WxCiB~CkBxA{@hF}C`FwCvG_E~a@_WnEkC~BuAlBkAZQxCgBvBoAfKkG~LqH^UvA{@r@c@hDsBt@e@dLaHVOd@Wb@Y|LqHnCcBfC}AfFaD`CwAbCwAt@c@n@[`A]dC_AXKdDmAv@YZMRI|EaB`@MVIXIf@G~@AHFFBHDJDJBJ@J?L@JAJAJCJEJEFEHEFGDEFIDIDIBK@K@K@I?I\c@n@i@hAe@RIHE`A]dBm@rAg@jFkBfC}@^MpG}Bx@YhG{BrDuApBs@z@]zPqGbHiC|OyF@?vn@oTXKjb@gOtX{JtKyDfMqErTcIfDkAh@SlB_Aj@[~FmDvCiBfC_BfKcH`@YlAs@jB}@|HyCp@UpA_@vA_@lCi@p@Kz@MhCa@vHmAzCa@bAGj@EfCClE?~HB`@@|@BjAJbCb@jBZnA^dFrAzJfCrEjAxAZPDlCPxABlB?fAArGEvEC|CATAhA?fA?V?fD@xBBzFRbCJx@?xBC`CGz@GPAjG]jReAzDG`A@X?dPRvBD|BDf@@vAEnCIjK[tRk@fCIxJ_@dHe@`Ig@x'
                        r'EYtAIdF]rAQn@IrCu@vAm@|BeAlDgB|EiChAq@dB{AfAmAV_@v@qAlA{B`AmBh@cATc@z@uAPSz@cAp@o@~AkAv@e@xAo@`DwAdBq@|@[t@SvA[dAOpG}@l@MtAa@dBq@|Aw@xBqAfKgGTObGmDrAaA|BgBjCuBzCsBXUtBgAz@_@tBs@xBm@vAWVEdBUnAKhBOrF_@vCYbBW~Be@pD{@rA[zD}@fDy@zAc@~Ao@`Bw@bBaA~@s@tAkAf@i@p@s@jC_D~AqB~D}EnBoBnIsH`A{@XSd@YdAe@nAa@v@O^GrBMxBEfEI|BIjAIpAQ~@QdA[rD{AbAc@lD}A|Aq@~As@`B}@|DkCjDcCtCsB\WXUhAy@xCsBROjEwCNMj@_@h@a@PMn@c@jFwDrBkAjAg@~CoArMcFrAg@hDgAtBe@jB]jB]|Dw@dFaAx@Sx@Un@Up@[f@[|@s@n@q@r@_A|@gBh@oBn@qCjBkIz@gDvAyFF[xDgQZyAfBeIZqBNuBIy^EgPEeHC{@SwBu@yEsA}Hy@_FkAuGWiBSkCKeD?_@@cAFqBJoB@MVcEJaC@aDEmBKmBU_Cy@uIKiBKyC@sB^mKt@kQt@sQHgCGoCGcA_@sD[yCOmBCeAKmDEqAa@kF]qEeA_MKoAGqAAoBBy@LuAZeCdAyGXaBj@kBTm@t@uA`@q@^m@pBeCxFuGvDsEvFyGfFkGjBuCb@w@xBsE|@iBzLyWfCqFfDeHZk@j@o@H?HAHCFCFEDGDEDGBI@I@G?I?GAEAEACn@s@v@o@r@c@t@_@~@YtAYl@KfB'
                        r'Il@?fBJ^D~@R~@ZbB|@rAr@hDlBfXrOrUzN`Aj@z@\|@Vn@JTDlALp@BfBCx@E~ScBhFs@|Hy@dJs@`CQrBQjBYRCn@OjFqAxEmAjA[rD}@rBi@xFyAlEgArEkA~HkB|Cq@REx@Q|AYzBUnAExB@jAFjBPfBZvA\bA^v@Zz@b@v@d@f@\t@l@bA~@bBvBj@|@z@bB~Rvb@z@hBv@rA`@l@n@v@z@z@p@j@pA~@`@RZPbAb@zBr@zElAbSfFhG~AnB`@`@FTDhBRrEZx@FnAHlEVnEZzCRfAF`AHbDPn@DpHNZBpBLd@DvDZ`CP`N|@lF\tIj@|ObA|@Hl@Px@\@?BHBHFHFFFFHFHDJBJBJ?J@HAJAHAHCHEHEFGFG@CBCBGBId@Ch@?vBLb@B~Gb@nF\nBLdPbAlEXxAJ~APjBb@l@TnAj@jAp@t@h@z@z@n@t@t@nAhBpDrIlQvHvOfEpIjBnD~FdLnKrS`CvE`IlOnAtBNTbDbFzSf[vEdHd@r@^j@tNjTnBtCf@`A^x@`@jAThAXpBbCzQRdB\dCn@pENz@Pt@Z~@j@pA`@r@|BtCzKlKpIfI~P`Pbe@vb@vGlGhFhFfBdBFJJZ?@?@?D@FBDBBBBDBDBD@D?F?D?BAV@VFxD|A\LfJpD^PjCdA|CpA^NjBv@bCbA|@\|HbDfEfB`Ab@\Th@z@?L@L?D@HBLDJDLFJ@TA^EXOZW\s@hA_@h@eEjG_CnDkBlCoAhBQRQVmAfBC?C?C?A?C@C@C@ABCB?BAB?@?B@B?@@B{AxBwCdEE?G?E@E@EBCB'
                        r'CBCDADAD?D?D@D@DBDBBBBBBD@D@D?D?FABADAhAvBR\l@hAR^r@rAxAnCT`@HPT^|@`BVf@DHT`@HN\n@JRT^fAtBXd@\l@NZt@vAVf@NZz@~Ax@SNGd@MlA[pA[vA]~@UTGYeA',
        price: 150000,
        availableSeats: 2,
        departureTime: DateTime.now().add(const Duration(days: 1)),
        status: 'open',
      ),
      TripModel(
        id: '2',
        driverId: 'd2',
        originName: 'Đồng Nai',
        destinationName: 'Vũng Tàu',
        originLat: 10.950564,
        originLng: 106.951246,
        destinationLat: 10.3460,
        destinationLng: 107.0843,
        routePolyline: r'swyaAi|wkSCuIzPxBd@JZJ^JxGrBnA`@zDlAhCv@j@PlK`DnA^PFh@PpCx@dDbAjBh@xC|@`AXv@Rv@Jt@HlBJrBJpK\nDJD?zQj@x@BdCHzOf@hADJ?dABhAD^@hJXz@HjAHnENjIT~@AhMnZbFpL|AvDpFlMnEnK~DlJhGxN`EvJzApD|CjHlMpZzJ|U`Qla@~DlJr@hBRp@t@pCd@~BTlBR~C`@zLBdAFpBNdFLfEHjCJ`DHjCFxBXpIHrCDrAJjDH~CFzAB`A?JNpEHbDBjA@hAC@EBADCBAD?B?D?D@B@D@DBBBBD@DBB?D?D?D?DABCDCBC@E@Et@GzAMr@Ir@Ov@Up@U\Qr@a@l@a@`@YRQ^a@b@m@rAuBx@kAz@_AlBaBvA}@jAo@pB_AnJiE|GaDbAo@b@[z@w@hAmAj@q@bA{AzAuCfH_NR[~AsBV]x@_AzC}ClBgBvE_ExAqAr@o@bD{CvBmBhBoAtBgAhAi@~MkEpAc@tCiAXQ`Am@`As@fAaAV[r@y@`@q@`AiBP[Vs@To@b@aBJc@V{@@IHWlEkPTu@z@uCRi@`@}@\k@`AwAp@y@fEcErIaI|@s@hAw@|A}@~DmBl@[tFmCb@St@_@~EqB`Ac@rDkBnEaCnAc@fCu@lLuCpEgAn@QtCu@pBc@rDu@xASlAM`BQ~Eg@~Ec@~BKxCEpB@vEP|ERtA@~BId@ETChAOtA[bCw@TIh@WTMhBiAfA}@h@e@^]hBaBj@g@f@e@v@s@tBcB`@]`BgA|A{@tCqAJElIqDjBw@j@UzKuEjAg@|B'
        r'aAr@[hEiBpKmEx@_@jF}BnAi@bIiDd@ShEiBzCqAdDsA|Bw@fBg@xA[vKuBvBa@`KoBlOyCdDq@xA]v@Sv@UdD_AtCaAxCaAns@_Vf@QbO_FzG{BxJaDrAc@d@OlN_ElP}EpNcExGmB~DkAb@M~Ae@nGiBlCs@hAUj@Iv@MxAOnAK|@Ed@A|DApFBfNNhDB`IFn@@v@Ah@CTCnAOjAQpMqCrDu@NCNAv@AVFF?n@@J?TCD?NCHATGPGTMXQ`Ac@FAnEs@rCa@n@IRE~AWvBe@vBo@bC_Al@UbCmAxEiCrBiAzDsBbB_AxA{@h@_@d@a@bBiBn@s@~CqD|HeJj@q@~AkBv@}@tAwAvAoAfHsFjDkCzRkOtL{ItJmHlEgDh@a@dAy@xLgJzBeBjBaBx@_A|@cApDwE~@sAb@s@r@kAtAsCfAsCnAoEfAaEbAuDl@uBz@aCXo@tBgFp@wAp@gAt@aAx@_AjAeAfF{DrDmCp@k@HInDyC~@w@hAaAbAu@vLaHv@_@~@_@hDmA|@[jDgA`Bo@dAi@z@g@`As@pC{B~DgDxAcA|AcAdLaHpDwBxG_EfBeAdBeAjDuB~BwA`@WxCiB~CkBxA{@hF}C`FwCvG_E~a@_WnEkC~BuAlBkAZQxCgBvBoAfKkG~LqH^UvA{@r@c@hDsBt@e@dLaHVOd@Wb@Y|LqHnCcBfC}AfFaD`CwAbCwAt@c@n@[`A]dC_AXKdDmAv@YZMRI|EaB`@MVIXIf@G~@AHFFBHDJDJBJ@J?L@JAJAJCJEJEFEHEFGDEFIDIDIBK@K@K@I'
        r'?I\c@n@i@hAe@RIHE`A]dBm@rAg@jFkBfC}@^MpG}Bx@YhG{BrDuApBs@z@]zPqGbHiC|OyF@?vn@oTXKjb@gOtX{JtKyDfMqErTcIfDkAh@SlB_Aj@[~FmDvCiBfC_BfKcH`@YlAs@jB}@|HyCp@UpA_@vA_@lCi@p@Kz@MhCa@vHmAzCa@bAGj@EfCClE?~HB`@@|@BjAJbCb@jBZnA^dFrAzJfCrEjAxAZPDlCPxABlB?fAArGEvEC|CATAhA?fA?V?fD@xBBzFRbCJx@?xBC`CGz@GPAjG]jReAzDG`A@X?dPRvBD|BDf@@vAEnCIjK[tRk@fCIxJ_@dHe@`Ig@xEYtAIdF]rAQn@IrCu@vAm@|BeAlDgB|EiChAq@dB{AfAmAV_@v@qAlA{B`AmBh@cATc@z@uAPSz@cAp@o@~AkAv@e@xAo@`DwAdBq@|@[t@SvA[dAOpG}@l@MtAa@dBq@|Aw@xBqAfKgGTObGmDrAaA|BgBjCuBzCsBXUtBgAz@_@tBs@xBm@vAWVEdBUnAKhBOrF_@vCYbBW~Be@pD{@rA[zD}@fDy@zAc@~Ao@`Bw@bBaA~@s@tAkAf@i@p@s@jC_D~AqB~D}EnBoBnIsH`A{@XSd@YdAe@nAa@v@O^GrBMxBEfEI|BIjAIpAQ~@QdA[rD{AbAc@lD}A|Aq@~As@`B}@|DkCjDcCtCsB\WXUhAy@xCsBROjEwCNMj@_@h@a@PMn@c@jFwDrBkAjAg@~CoArMcFrAg@hDgAtBe@jB]jB]|Dw@dFaAx@Sx@Un@Up@[f@[|@s'
        r'@n@q@r@_A|@gBh@oBn@qCjBkIz@gDvAyFF[xDgQZyAfBeIZqBNuBIy^EgPEeHC{@SwBu@yEsA}Hy@_FkAuGWiBSkCKeD?_@@cAFqBJoB@MVcEJaC@aDEmBKmBU_Cy@uIKiBKyC@sB^mKt@kQt@sQHgCGoCGcA_@sD[yCOmBCeAKmDEqAa@kF]qEeA_MKoAGqAAoBBy@LuAZeCdAyGXaBj@kBTm@t@uA`@q@^m@pBeCxFuGvDsEvFyGfFkGjBuCb@w@xBsE|@iBzLyWfCqFfDeHZk@j@o@H?HAHCFCFEDGDEDGBI@I@G?I?GAEAEACn@s@v@o@r@c@t@_@~@YtAYl@KfBIl@?fBJ^D~@R~@ZbB|@rAr@hDlBfXrOrUzN`Aj@z@\|@Vn@JTDlALp@BfBCx@E~ScBhFs@|Hy@dJs@`CQrBQjBYRCn@OjFqAxEmAjA[rD}@rBi@xFyAlEgArEkA~HkB|Cq@REx@Q|AYzBUnAExB@jAFjBPfBZvA\bA^v@Zz@b@v@d@f@\t@l@bA~@bBvBj@|@z@bB~Rvb@z@hBv@rA`@l@n@v@z@z@p@j@pA~@`@RZPbAb@zBr@zElAbSfFhG~AnB`@`@FTDhBRrEZx@FnAHlEVnEZzCRfAF`AHbDPn@DpHNZBpBLd@DvDZ`CP`N|@lF\tIj@|ObA|@Hl@Px@\@?BHBHFHFFFFHFHDJBJBJ?J@HAJAHAHCHEHEFGFG@CBCBGBId@Ch@?vBLb@B~Gb@nF\nBLdPbAlEXxAJ~APjBb@l@TnAj@jAp@t@h@z@z@n@t@t@nAhBpD'
        r'rIlQvHvOfEpIjBnD~FdLnKrS`CvE`IlOnAtBNTbDbFzSf[vEdHd@r@^j@tNjTnBtCf@`A^x@`@jAThAXpBbCzQRdB\dCn@pENz@Pt@Z~@j@pA`@r@|BtCzKlKpIfI~P`Pbe@vb@vGlGhFhFfBdBFJJZ?@?@?D@FBDBBBBDBDBD@D?F?D?BAV@VFxD|A\LfJpD^PjCdA|CpA^NjBv@bCbA|@\|HbDfEfB`Ab@\Th@z@?L@L?D@HBLDJDLFJ@TA^EXOZW\s@hA_@h@eEjG_CnDkBlCoAhBPL`CjAfEjBbAd@xB`AzAl@l@TdAb@|FxBPFhA`@`Bh@pA`@|Aj@',
        price: 350000,
        availableSeats: 2,
        departureTime: DateTime.now().add(const Duration(hours: 3)),
        status: 'open',
      ),
      TripModel(
        id: '3',
        driverId: 'd3',
        originName: 'Đà Nẵng',
        destinationName: 'Hội An',
        originLat: 16.0544,
        originLng: 108.2022,
        destinationLat: 15.8801,
        destinationLng: 108.3380,
        routePolyline: '',
        price: 100000,
        availableSeats: 6,
        departureTime: DateTime.now().add(const Duration(days: 1)),
        status: 'open',
      ),
    ];
  }
}
