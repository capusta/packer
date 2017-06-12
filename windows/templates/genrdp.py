#! /usr/bin/env python
import sys
import re
import os
infile, outdir = sys.argv[1], sys.argv[2]

with open(infile) as inf:
    for line in inf:
        pattern = re.compile("^#node")
        if pattern.match(line):
            line = line.split(':')
            f = os.path.join(sys.argv[2],line[1]+".rdp")
            t = open(f,'w')
            template = """
            screen mode id:i:2
            use multimon:i:0
            desktopwidth:i:1920
            desktopheight:i:1080
            session bpp:i:32
            winposstr:s:0,3,0,0,800,600
            compression:i:1
            keyboardhook:i:2
            audiocapturemode:i:0
            videoplaybackmode:i:1
            connection type:i:7
            networkautodetect:i:1
            bandwidthautodetect:i:1
            displayconnectionbar:i:1
            username:s:{nuser}
            enableworkspacereconnect:i:0
            disable wallpaper:i:0
            allow font smoothing:i:0
            allow desktop composition:i:0
            disable full window drag:i:1
            disable menu anims:i:1
            disable themes:i:0
            disable cursor setting:i:0
            bitmapcachepersistenable:i:1
            full address:s:{ip}
            audiomode:i:0
            redirectprinters:i:1
            redirectcomports:i:0
            redirectsmartcards:i:1
            redirectclipboard:i:1
            redirectposdevices:i:0
            autoreconnection enabled:i:1
            authentication level:i:2
            prompt for credentials:i:0
            negotiate security layer:i:1
            remoteapplicationmode:i:0
            alternate shell:s:
            shell working directory:s:
            gatewayhostname:s:
            gatewayusagemethod:i:4
            gatewaycredentialssource:i:4
            gatewayprofileusagemethod:i:0
            promptcredentialonce:i:0
            gatewaybrokeringtype:i:0
            use redirection server name:i:0
            rdgiskdcproxy:i:0
            kdcproxyname:s:
            """
            import getpass
            username = getpass.getuser()
            context = {
                "ip":line[2],
                "nuser":username
            }
            t.write(template.format(**context))
            t.close()