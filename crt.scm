; CRT v1.0
; Tested on Gimp v2.8
(define (script-fu-crt image drawable)
  ; Start an undo group
  (gimp-image-undo-group-start image)

  ; Save the context
  (gimp-context-push)

  ; Set the background color to black
  (gimp-context-set-background '(0 0 0))

  ; Scalings will be done without interpolation
  (gimp-context-set-interpolation INTERPOLATION-NONE)

  (let* (; Retrieve width and height of the original image
          (width (car (gimp-image-width image)))
          (height (car (gimp-image-height image)))
        )
    ; Scale the image × 2
    (gimp-image-scale image (* 2 width) (* 2 height))

    ; Create the scanlines by removing even lines (no info is lost since the
    ; image was upscaled)
    (script-fu-erase-rows image drawable 0 0 0)

    ; Scale the image × 8
    (gimp-image-scale image (* 8 width) (* 8 height))

    ; Ensure there is no transparent background after script-fu-erase-rows
    (gimp-layer-flatten drawable)

    ; Lines drawn on the CRT are not perfect, add some imperfections
    (plug-in-spread RUN-NONINTERACTIVE image drawable 2 2)

    ; Dots drawn on the CRT are not squares
    (plug-in-gauss-rle2 RUN-NONINTERACTIVE image drawable 8 4)

    ; Compensate lost luminosity
    (gimp-curves-spline drawable HISTOGRAM-VALUE 6 #(0 0 96 192 255 255))

    ; Traditional CRTs are not flat, add concativity
    (plug-in-lens-distortion RUN-NONINTERACTIVE image drawable 0 0 10 0 0 20)

    ; Add an extra layer of black noise
    (let* ((layer (car (gimp-layer-new image (* 8 width) (* 8 height)
                        RGB-IMAGE "Noise" 100 LIGHTEN-ONLY-MODE))))

      (gimp-image-insert-layer image layer 0 -1)

      ; Do the noise
      (plug-in-rgb-noise RUN-NONINTERACTIVE image layer 0 0 0.3 0.3 0.3 0.3)

      ; Blur the noise to make it more realistic
      (plug-in-gauss-rle2 RUN-NONINTERACTIVE image layer 24 24)
    )
  )

  ; Restore the original context
  (gimp-context-pop)

  ; End the undo group
  (gimp-image-undo-group-end image)

  ; Flush the display
  (gimp-displays-flush)
)

(script-fu-register "script-fu-crt"
  "<Image>/Filters/Distorts/CRT emulator"
  "CRT emulator"
  "Frédéric BISSON"
  "Frédéric BISSON"
  "01/11/2014"
  "RGB*"
  SF-IMAGE "Image"  0
  SF-DRAWABLE "Drawable" 0
)
