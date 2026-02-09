from moviepy import VideoFileClip, vfx

try:
    print("Cargando video...")
    clip = VideoFileClip("assets/time_lapse_bicicoruna.mp4")
    
    # Reducir tamaño y duración para GitHub (<10MB ideal, máx 25MB)
    # 1. Acelerar x4 (56s -> 14s)
    # 2. Reducir resolución (width=600px es estándar para README)
    # 3. Bajar FPS a 10 (suficiente para timelapse)
    print("Procesando clip...")
    final_clip = clip.resized(width=600).with_effects([vfx.MultiplySpeed(4)])
    
    output_path = "assets/timelapse_preview.gif"
    print(f"Generando GIF en {output_path}...")
    final_clip.write_gif(output_path, fps=10, logger="bar")
    
    print("¡GIF generado con éxito!")

except Exception as e:
    print(f"Error al generar GIF: {e}")
