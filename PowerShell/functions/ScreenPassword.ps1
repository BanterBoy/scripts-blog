function ScreenPassword($instance)
          {
              if (!($instance.screensaversecure)) {return $instance.name}
              <additional statements>
          }

          foreach ($a in @(get-wmiobject win32_desktop)) { ScreenPassword($a) }