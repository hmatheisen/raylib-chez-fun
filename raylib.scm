(load-shared-object "/opt/homebrew/lib/libraylib.dylib")

;; Window
(define (init-window width height title)
  ((foreign-procedure "InitWindow" (int int string) void)
   width height title))

(define (close-window)
  ((foreign-procedure "CloseWindow" () void)))

(define (window-should-close?)
  ((foreign-procedure "WindowShouldClose" () boolean)))

(define (set-target-fps fps)
  ((foreign-procedure "SetTargetFPS" (int) void)
   fps))

(define FLAG_WINDOW_UNDECORATED 8)
(define FLAG_WINDOW_TRANSPARENT 16)

(define (set-config-flags flags)
  ((foreign-procedure "SetConfigFlags" (unsigned-int) void)
   flags))

(define (set-window-state state)
  ((foreign-procedure "SetWindowState" (unsigned-int) void)
   state))

;; Keys
(define (is-key-down? key)
  ((foreign-procedure "IsKeyDown" (int) boolean)
   key))

(define KEY_RIGHT 262)
(define KEY_LEFT 263)
(define KEY_DOWN 264)
(define KEY_UP 265)
(define KEY_Q 81)

(define (set-exit-key key)
  ((foreign-procedure "SetExitKey" (int) void)
   key))

;; Vector 2
(define-ftype Vector2
  (struct
    [x float]
    [y float]))

(define (make-vector2 x y)
  (let ((struct (make-ftype-pointer
                 Vector2
                 (foreign-alloc (ftype-sizeof Vector2)))))
    (ftype-set! Vector2 (x) struct x)
    (ftype-set! Vector2 (y) struct y)
    struct))

(define-syntax vector-2-set!
  (syntax-rules ()
    ((_ struct field value)
     (ftype-set! Vector2 (field) struct value))))

(define-syntax vector-2-get
  (syntax-rules ()
    ((_ struct field)
     (ftype-ref Vector2 (field) struct))))

;; Vector 3
(define-ftype Vector3
  (struct
    [x float]
    [y float]
    [z float]))

(define-syntax vector-3-set!
  (syntax-rules ()
    ((_ struct field value)
     (ftype-set! Vector3 (field) struct value))))

(define-syntax vector-3-get
  (syntax-rules ()
    ((_ struct field)
     (ftype-ref Vector3 (field) struct))))

(define (make-vector3 x y z)
  (let ((struct (make-ftype-pointer
                 Vector3
                 (foreign-alloc (ftype-sizeof Vector3)))))
    (vector-3-set! struct x x)
    (vector-3-set! struct y y)
    (vector-3-set! struct z z)
    struct))

;; Drawing
(define (begin-drawing)
  ((foreign-procedure "BeginDrawing" () void)))

(define (end-drawing)
  ((foreign-procedure "EndDrawing" () void)))

(define-syntax drawing-begin
  (syntax-rules ()
    ((_ body ...)
     (begin
       (begin-drawing)
       body
       ...
       (end-drawing)))))

(define-ftype Camera2D
  (struct
    [offset Vector2]
    [target Vector2]
    [rotation float]
    [zoom float]))

(define (make-camera-2d offset target rotation zoom)
  (let ((struct (make-ftype-pointer
                 Camera2D
                 (foreign-alloc (ftype-sizeof Camera2D)))))
    (ftype-&ref Camera2D (offset) struct offset)
    (ftype-&ref Camera2D (target) struct target)
    (ftype-set! Camera2D (rotation) struct rotation)
    (ftype-set! Camera2D (zoom) struct zoom)
    struct))

(define-ftype Camera3D
  (struct
    [position Vector3]
    [target Vector3]
    [up Vector3]
    [fovy float]
    [projection int]))

(define (camera-3d-set-position! camera position)
  (ftype-set! Camera3D (position x) camera (vector-3-get position x))
  (ftype-set! Camera3D (position y) camera (vector-3-get position y))
  (ftype-set! Camera3D (position z) camera (vector-3-get position z)))

(define (camera-3d-set-target! camera target)
  (ftype-set! Camera3D (target x) camera (vector-3-get target x))
  (ftype-set! Camera3D (target y) camera (vector-3-get target y))
  (ftype-set! Camera3D (target z) camera (vector-3-get target z)))

(define (camera-3d-set-up! camera up)
  (ftype-set! Camera3D (up x) camera (vector-3-get up x))
  (ftype-set! Camera3D (up y) camera (vector-3-get up y))
  (ftype-set! Camera3D (up z) camera (vector-3-get up z)))

(define (make-camera-3d position target up fovy projection)
  (let ((struct (make-ftype-pointer
                 Camera3D
                 (foreign-alloc (ftype-sizeof Camera3D)))))
    (camera-3d-set-position! struct position)
    (camera-3d-set-target! struct target)
    (camera-3d-set-up! struct up)
    (ftype-set! Camera3D (fovy) struct fovy)
    (ftype-set! Camera3D (projection) struct projection)
    struct))

(define (update-camera camera mode)
  ((foreign-procedure "UpdateCamera" ((* Camera3D) int) void)
   camera mode))

;; Camera system modes
(define CAMERA_FREE 1)
(define CAMERA_ORBITAL 2)

;; Camera projection
(define CAMERA_PERSPECTIVE 0)
(define CAMERA_ORTHOGRAPHIC 1)

(define (begin-mode-2d camera)
  ((foreign-procedure "BeginMode2D" ((& Camera2D)) void)
   camera))

(define (end-mode-2d)
  ((foreign-procedure "EndMode2D" () void)))

(define (begin-mode-3d camera)
  ((foreign-procedure "BeginMode3D" ((& Camera3D)) void)
   camera))

(define (end-mode-3d)
  ((foreign-procedure "EndMode3D" () void)))

(define-syntax mode-3d-begin
  (syntax-rules ()
    ((_ camera body ...)
     (begin
       (begin-mode-3d camera)
       body
       ...
       (end-mode-3d)))))

(define-ftype Color
  (struct
    [r unsigned-8]
    [g unsigned-8]
    [b unsigned-8]
    [a unsigned-8]))

(define (make-color r g b a)
  (let ((struct (make-ftype-pointer
                 Color
                 (foreign-alloc (ftype-sizeof Color)))))
    (ftype-set! Color (r) struct r)
    (ftype-set! Color (g) struct g)
    (ftype-set! Color (b) struct b)
    (ftype-set! Color (a) struct a)
    struct))

(define RAYWHITE (make-color 245 245 245 255))
(define LIGHTGRAY (make-color 200 200 200 255))
(define BLACK (make-color 0 0 0 255))
(define BLANK (make-color 0 0 0 0))
(define MAROON (make-color 190 33 55 255))

(define (clear-background color)
  ((foreign-procedure "ClearBackground" ((& Color)) void)
   color))

(define (draw-text text x y font-size color)
  ((foreign-procedure "DrawText" (string int int int (& Color)) void)
   text x y font-size color))

(define (draw-grid slices spacing)
  ((foreign-procedure "DrawGrid" (int float) void)
   slices spacing))

(define (draw-circle-v center radius color)
  ((foreign-procedure "DrawCircleV" ((& Vector2) float (& Color)) void)
   center radius color))

(define (draw-cube position width height length color)
  ((foreign-procedure "DrawCube" ((& Vector3) float float float (& Color)) void)
   position width height length color))

(define (draw-cube-wires position width height length color)
  ((foreign-procedure "DrawCubeWires" ((& Vector3) float float float (& Color)) void)
   position width height length color))

;; Texture
(define-ftype Texture2D
  (struct
    [id unsigned-int]
    [width int]
    [height int]
    [mipmaps int]
    [format int]))

(define (load-texture file-name)
  (let ((texture (make-ftype-pointer
                  Texture2D
                  (foreign-alloc (ftype-sizeof Texture2D)))))
    ((foreign-procedure "LoadTexture" (string) (& Texture2D))
     texture file-name)
    texture))

(define (unload-texture texture)
  ((foreign-procedure "UnloadTexture" ((& Texture2D)) void)
   texture))

(define (draw-texture texture pos-x pos-y color)
  ((foreign-procedure "DrawTexture" ((& Texture2D) int int (& Color)) void)
   texture pos-x pos-y color))

(define-syntax texture-2d-get
  (syntax-rules ()
    ((_ struct field)
     (ftype-ref Texture2D (field) struct))))

;; Cursor
(define (disable-cursor)
  ((foreign-procedure "DisableCursor" () void)))
