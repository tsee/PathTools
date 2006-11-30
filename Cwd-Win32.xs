#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#define NEED_sv_2pv_nolen
#include "ppport.h"

#ifdef I_UNISTD
#   include <unistd.h>
#endif

MODULE = Cwd		PACKAGE = Cwd

PROTOTYPES: ENABLE

void
getdcwd(...)
PPCODE:
{
    dXSTARG;
    int drive;
    char *dir;

    /* Drive 0 is the current drive, 1 is A:, 2 is B:, 3 is C: and so on. */
    if ( items == 0 ||
        (items == 1 && (!SvOK(ST(0)) || (SvPOK(ST(0)) && !SvCUR(ST(0))))))
        drive = 0;
    else if (items == 1 && SvPOK(ST(0)) && SvCUR(ST(0)) &&
             isALPHA(SvPVX(ST(0))[0]))
        drive = toUPPER(SvPVX(ST(0))[0]) - 'A' + 1;
    else
        croak("Usage: getdcwd(DRIVE)");

    New(0,dir,MAXPATHLEN,char);
    if (_getdcwd(drive, dir, MAXPATHLEN)) {
        sv_setpvn(TARG, dir, strlen(dir));
        SvPOK_only(TARG);
    }
    else
        sv_setsv(TARG, &PL_sv_undef);

    Safefree(dir);

    XSprePUSH; PUSHTARG;
#ifndef INCOMPLETE_TAINTS
    SvTAINTED_on(TARG);
#endif
}
