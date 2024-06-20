(include "raylib.scm")

(define screen-width 800)
(define screen-height 600)

(set-config-flags FLAG_WINDOW_TRANSPARENT)
(set-window-state FLAG_WINDOW_UNDECORATED)
(init-window screen-width screen-height "Raylib Scheme")
(set-exit-key KEY_Q)

(define camera3d
  (make-camera-3d (make-vector3 10.0 10.0 10.0)
                  (make-vector3 0.0 0.0 0.0)
                  (make-vector3 0.0 1.0 0.0)
                  15.0
                  CAMERA_PERSPECTIVE))

(define cube-position (make-vector3 0.0 0.0 0.0))

(set-target-fps 60)

(define (main-loop)
  (unless (window-should-close?)

    (update-camera camera3d CAMERA_ORBITAL)

    (drawing-begin
     (clear-background BLANK)
     (mode-3d-begin
      camera3d
      (draw-cube-wires cube-position 2.0 2.0 2.0 MAROON)))

    (main-loop)))

(main-loop)
(close-window)
