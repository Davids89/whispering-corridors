#!/usr/bin/env python3
"""
Portrait Generator — Whispering Corridors
Inquisidor del Vacío: 5 damage states, 64x64 pixel art, Doom/Quake style.
Pure stdlib PNG writer (no dependencies).
"""
import struct, zlib, os

# ============================================================
# PALETTE — Lovecraftian Inquisitor (28 colors)
# ============================================================
PAL = {
    '.': None,                # transparent
    # Hood / cloth (dark purples & blacks)
    'K': (10, 5, 16),         # #0A0510 deepest black-purple
    'H': (26, 16, 37),        # #1A1025 hood dark
    'h': (42, 26, 56),        # #2A1A38 hood mid
    'P': (62, 40, 80),        # #3E2850 hood light / purple accent
    'p': (88, 58, 110),       # #583A6E purple highlight
    # Skin (pale, gaunt, sickly)
    'S': (201, 178, 155),     # #C9B29B skin base
    's': (171, 145, 122),     # #AB917A skin shadow
    'D': (138, 112, 92),      # #8A705C skin deep shadow
    'd': (105, 82, 66),       # #695242 darkest skin
    'E': (222, 205, 186),     # #DECDBA skin highlight
    # Spectral green (eyes, corruption glow)
    'G': (57, 255, 141),      # #39FF8D spectral bright
    'g': (30, 180, 100),      # #1EB464 spectral mid
    'V': (16, 110, 62),       # #106E3E spectral dark
    'v': (8, 60, 34),         # #083C22 spectral deepest
    # Blood (dark crimson, dried)
    'B': (164, 22, 26),       # #A4161A blood bright
    'b': (117, 12, 18),       # #750C12 blood mid
    'R': (74, 6, 12),         # #4A060C blood dark / dried
    # Corruption / void (bruises, veins)
    'C': (94, 42, 132),       # #5E2A84 corruption purple
    'c': (56, 22, 82),        # #381652 corruption dark
    # Teeth / bone
    'W': (230, 224, 210),     # #E6E0D2 bone white
    'w': (180, 172, 155),     # #B4AC9B bone shadow
    # Eye white (sickly)
    'Y': (214, 210, 180),     # #D6D2B4 sickly eye white
    # Metal (inquisitor gorget/collar)
    'M': (120, 118, 130),     # #787682 metal mid
    'm': (70, 68, 82),        # #464452 metal dark
    'L': (170, 168, 178),     # #AAA8B2 metal light
    # Scar / stitch
    'T': (90, 60, 55),        # #5A3C37 scar tissue
}

# ============================================================
# Helper: build image from rows of palette chars
# ============================================================
def rows_to_pixels(rows):
    h = len(rows)
    w = len(rows[0])
    px = [[None]*w for _ in range(h)]
    for y, row in enumerate(rows):
        assert len(row) == w, f"Row {y} has width {len(row)}, expected {w}"
        for x, ch in enumerate(row):
            px[y][x] = PAL[ch]
    return px, w, h

# ============================================================
# PNG writer (RGBA, no filter)
# ============================================================
def write_png(path, pixels, w, h):
    raw = b''
    for y in range(h):
        raw += b'\x00'
        for x in range(w):
            c = pixels[y][x]
            if c is None:
                raw += bytes((0, 0, 0, 0))
            else:
                raw += bytes((c[0], c[1], c[2], 255))
    def chunk(tag, data):
        c = struct.pack('>I', len(data)) + tag + data
        return c + struct.pack('>I', zlib.crc32(tag + data) & 0xffffffff)
    png = b'\x89PNG\r\n\x1a\n'
    png += chunk(b'IHDR', struct.pack('>IIBBBBB', w, h, 8, 6, 0, 0, 0))
    png += chunk(b'IDAT', zlib.compress(raw, 9))
    png += chunk(b'IEND', b'')
    with open(path, 'wb') as f:
        f.write(png)

def upscale(pixels, w, h, factor):
    nw, nh = w*factor, h*factor
    out = [[None]*nw for _ in range(nh)]
    for y in range(nh):
        for x in range(nw):
            out[y][x] = pixels[y//factor][x//factor]
    return out, nw, nh

# ============================================================
# BASE PORTRAIT — 64x64
# Inquisidor del Vacío: hooded, gaunt, spectral eyes.
# Canvas layout: hood frames the face, face occupies center,
# gorget/collar at bottom. Front view, slight shadows.
# ============================================================

# We build the face programmatically in layers for consistency
# across damage states.

W = H = 64

def base_canvas():
    return [[None]*W for _ in range(H)]

def put(px, x, y, ch):
    if 0 <= x < W and 0 <= y < H:
        px[y][x] = ch

def fill_rect(px, x0, y0, x1, y1, ch):
    for y in range(y0, y1+1):
        for x in range(x0, x1+1):
            put(px, x, y, ch)

def draw_hood(px):
    """Hood: frames face, dark purple. Occupies top and sides."""
    # Top dome of the hood
    for y in range(0, 20):
        # hood width grows as we go down
        half = 8 + y  # starts narrow
        cx = 32
        for x in range(cx-half, cx+half+1):
            put(px, x, y, 'K')
    # Hood sides going down
    for y in range(20, 52):
        for x in range(0, 14):
            put(px, x, y, 'K')
        for x in range(50, 64):
            put(px, x, y, 'K')
    # Inner hood shading (mid tone) — creates depth around face
    for y in range(4, 18):
        half = 6 + y
        cx = 32
        for x in range(cx-half, cx+half+1):
            put(px, x, y, 'H')
    for y in range(18, 50):
        for x in range(10, 16):
            put(px, x, y, 'H')
        for x in range(48, 54):
            put(px, x, y, 'H')
    # Hood highlight folds (left side catches faint light)
    for y in range(8, 44):
        put(px, 12, y, 'h')
        put(px, 13, y, 'h')
    for y in range(10, 30):
        put(px, 11, y, 'h')
    # Right side deeper shadow fold
    for y in range(8, 44):
        put(px, 51, y, 'h')
        put(px, 52, y, 'h')
    # Hood bottom edge / shoulders
    for y in range(52, 64):
        for x in range(0, 64):
            put(px, x, y, 'K')
    # Shoulder cloth shading
    for y in range(54, 64):
        for x in range(4, 60):
            put(px, x, y, 'H')
    for y in range(56, 64):
        for x in range(8, 56):
            put(px, x, y, 'h')

def draw_gorget(px):
    """Metal inquisitor collar/gorget at neck."""
    for y in range(50, 56):
        for x in range(22, 42):
            put(px, x, y, 'm')
    for y in range(50, 53):
        for x in range(24, 40):
            put(px, x, y, 'M')
    # Center sigil (spectral green inquisitor seal)
    fill_rect(px, 30, 51, 33, 54, 'V')
    put(px, 31, 52, 'g')
    put(px, 32, 52, 'g')
    put(px, 31, 53, 'V')
    put(px, 32, 53, 'V')
    # Metal rivets
    put(px, 24, 51, 'L')
    put(px, 39, 51, 'L')

def draw_face_base(px):
    """Skin: gaunt face, front view. Face spans x20-43, y16-50."""
    # Face silhouette
    rows = [
        (16, 26, 37),  # forehead top
        (17, 24, 39),
        (18, 23, 40),
        (19, 22, 41),
        (20, 21, 42),
        (21, 21, 42),
        (22, 20, 43),
        (23, 20, 43),
        (24, 20, 43),
        (25, 20, 43),
        (26, 20, 43),
        (27, 20, 43),
        (28, 20, 43),
        (29, 20, 43),
        (30, 20, 43),
        (31, 20, 43),
        (32, 20, 43),
        (33, 20, 43),
        (34, 20, 43),
        (35, 20, 43),
        (36, 20, 43),
        (37, 21, 42),
        (38, 21, 42),
        (39, 21, 42),
        (40, 22, 41),
        (41, 22, 41),
        (42, 23, 40),
        (43, 23, 40),
        (44, 24, 39),
        (45, 24, 39),
        (46, 25, 38),
        (47, 26, 37),
        (48, 27, 36),
        (49, 28, 35),
        (50, 29, 34),
    ]
    for y, x0, x1 in rows:
        for x in range(x0, x1+1):
            put(px, x, y, 'S')
    # Base shading: right side shadow (light from upper-left)
    for y, x0, x1 in rows:
        w = x1 - x0
        # right third shadow
        sh = max(1, w // 3)
        for x in range(x1-sh+1, x1+1):
            put(px, x, y, 's')
        # far right edge deep shadow
        put(px, x1, y, 'D')
    # Left highlight
    for y, x0, x1 in rows:
        if 20 <= y <= 44:
            put(px, x0, y, 'E')
            if y < 40:
                put(px, x0+1, y, 'E')
    # Jaw shading
    for y in range(42, 51):
        for x in range(24, 40):
            c = px[y][x]
            if c == 'S':
                put(px, x, y, 's')
    # Chin shadow
    for x in range(28, 36):
        put(px, x, 49, 'D')
        put(px, x, 50, 'D')

def draw_brow(px, frown=0):
    """Brow ridge. frown: 0 neutral, 1 slight, 2 strong."""
    # Brow bone shadow line
    for x in range(23, 41):
        put(px, x, 26, 'D')
    # Eyebrows (dark)
    if frown == 0:
        for x in range(24, 29):
            put(px, x, 25, 'd')
        for x in range(35, 40):
            put(px, x, 25, 'd')
    elif frown == 1:
        # inner ends dip
        for x in range(24, 29):
            put(px, x, 25, 'd')
        for x in range(35, 40):
            put(px, x, 25, 'd')
        put(px, 28, 26, 'd')
        put(px, 35, 26, 'd')
        # forehead crease
        put(px, 31, 22, 's')
        put(px, 32, 22, 's')
        put(px, 31, 23, 's')
        put(px, 32, 23, 's')
    else:
        # strong frown: brows angle down hard
        for x in range(24, 29):
            put(px, x, 24 + (28-x)//3, 'd')
        for x in range(35, 40):
            put(px, x, 24 + (x-35)//3, 'd')
        put(px, 29, 26, 'd')
        put(px, 34, 26, 'd')
        # deep forehead creases
        for x in range(29, 35):
            put(px, x, 21, 's')
            put(px, x, 23, 's')
        put(px, 31, 22, 'D')
        put(px, 32, 22, 'D')

def draw_eyes(px, state):
    """Eyes: sunken, spectral green glow intensifies with corruption.
    state: 1..5"""
    # Eye sockets (sunken shadow)
    fill_rect(px, 24, 28, 29, 31, 'd')
    fill_rect(px, 34, 28, 39, 31, 'd')
    # Eye balls (sickly white)
    fill_rect(px, 25, 29, 28, 30, 'Y')
    fill_rect(px, 35, 29, 38, 30, 'Y')
    if state == 1:
        # Determined: small green iris, focused
        put(px, 27, 29, 'g'); put(px, 27, 30, 'g')
        put(px, 36, 29, 'g'); put(px, 36, 30, 'g')
        put(px, 27, 29, 'V')
        put(px, 36, 29, 'V')
    elif state == 2:
        # Worried: eyes slightly wider, iris visible
        put(px, 26, 29, 'g'); put(px, 27, 29, 'g')
        put(px, 26, 30, 'V'); put(px, 27, 30, 'V')
        put(px, 36, 29, 'g'); put(px, 37, 29, 'g')
        put(px, 36, 30, 'V'); put(px, 37, 30, 'V')
    elif state == 3:
        # Pain: one eye squinting (left), other bloodshot wide
        fill_rect(px, 25, 29, 28, 30, 'Y')
        put(px, 25, 30, 's')  # squint shadow
        put(px, 26, 30, 's')
        put(px, 27, 29, 'g')
        # right eye wide + bloodshot
        put(px, 36, 29, 'G'); put(px, 37, 29, 'g')
        put(px, 36, 30, 'g'); put(px, 37, 30, 'V')
        put(px, 35, 29, 'B')  # blood vessel
        put(px, 38, 30, 'B')
    elif state == 4:
        # Agony: both eyes wide, glowing harder, veins
        fill_rect(px, 25, 28, 28, 31, 'Y')
        fill_rect(px, 35, 28, 38, 31, 'Y')
        put(px, 26, 29, 'G'); put(px, 27, 29, 'G')
        put(px, 26, 30, 'g'); put(px, 27, 30, 'g')
        put(px, 36, 29, 'G'); put(px, 37, 29, 'G')
        put(px, 36, 30, 'g'); put(px, 37, 30, 'g')
        # bloodshot
        put(px, 25, 28, 'B'); put(px, 28, 31, 'B')
        put(px, 38, 28, 'B'); put(px, 35, 31, 'B')
        # dark bags
        for x in range(25, 29):
            put(px, x, 32, 'c')
        for x in range(35, 39):
            put(px, x, 32, 'c')
    else:
        # Critical: eyes desencajados — fully glowing spectral, rolled
        fill_rect(px, 25, 28, 28, 31, 'v')
        fill_rect(px, 35, 28, 38, 31, 'v')
        put(px, 26, 29, 'G'); put(px, 27, 29, 'G')
        put(px, 26, 30, 'G'); put(px, 27, 30, 'G')
        put(px, 36, 29, 'G'); put(px, 37, 29, 'G')
        put(px, 36, 30, 'G'); put(px, 37, 30, 'G')
        # glow bleed
        put(px, 25, 28, 'g'); put(px, 28, 28, 'g')
        put(px, 35, 28, 'g'); put(px, 38, 28, 'g')
        put(px, 24, 29, 'V'); put(px, 29, 29, 'V')
        put(px, 34, 29, 'V'); put(px, 39, 29, 'V')
        # heavy corruption bags
        for x in range(24, 30):
            put(px, x, 32, 'c')
            put(px, x, 33, 'C')
        for x in range(34, 40):
            put(px, x, 32, 'c')
            put(px, x, 33, 'C')

def draw_nose(px):
    """Gaunt nose."""
    put(px, 31, 32, 's')
    put(px, 32, 32, 's')
    put(px, 31, 33, 's')
    put(px, 32, 33, 's')
    put(px, 30, 34, 's')
    put(px, 31, 34, 'D')
    put(px, 32, 34, 'D')
    put(px, 33, 34, 's')
    # nostrils
    put(px, 30, 35, 'd')
    put(px, 33, 35, 'd')
    put(px, 31, 35, 's')
    put(px, 32, 35, 's')
    # highlight
    put(px, 31, 31, 'E')

def draw_mouth(px, state):
    """Mouth: state 1 determined line, escalating to grimace/scream."""
    if state == 1:
        # Determined thin line
        for x in range(28, 36):
            put(px, x, 41, 'd')
        put(px, 27, 41, 's')
        put(px, 36, 41, 's')
        put(px, 28, 42, 's')
        put(px, 35, 42, 's')
    elif state == 2:
        # Slight tension, corner down
        for x in range(28, 36):
            put(px, x, 41, 'd')
        put(px, 27, 42, 'd')
        put(px, 36, 42, 'd')
        put(px, 28, 42, 's')
        put(px, 35, 42, 's')
    elif state == 3:
        # Pain: clenched teeth showing
        for x in range(27, 37):
            put(px, x, 40, 'd')
        for x in range(28, 36):
            put(px, x, 41, 'W')
        # teeth lines
        put(px, 30, 41, 'w')
        put(px, 32, 41, 'w')
        put(px, 34, 41, 'w')
        for x in range(28, 36):
            put(px, x, 42, 'd')
    elif state == 4:
        # Agony: open grimace, teeth bared
        for x in range(27, 37):
            put(px, x, 40, 'd')
        for x in range(28, 36):
            put(px, x, 41, 'W')
            put(px, x, 42, 'w')
        put(px, 30, 41, 'd'); put(px, 32, 41, 'd'); put(px, 34, 41, 'd')
        put(px, 30, 42, 'd'); put(px, 32, 42, 'd'); put(px, 34, 42, 'd')
        for x in range(28, 36):
            put(px, x, 43, 'd')
        # blood from mouth corner
        put(px, 37, 42, 'B')
        put(px, 37, 43, 'B')
        put(px, 38, 44, 'b')
        put(px, 38, 45, 'b')
    else:
        # Critical: screaming, mouth open dark, blood
        for x in range(27, 37):
            put(px, x, 40, 'd')
        for x in range(28, 36):
            put(px, x, 41, 'W')
        put(px, 30, 41, 'd'); put(px, 32, 41, 'd'); put(px, 34, 41, 'd')
        # open dark mouth
        for x in range(29, 35):
            put(px, x, 42, 'K')
            put(px, x, 43, 'K')
        put(px, 30, 44, 'K'); put(px, 33, 44, 'K')
        put(px, 31, 44, 'R'); put(px, 32, 44, 'R')
        for x in range(28, 36):
            put(px, x, 45, 'd')
        # blood pouring from mouth
        put(px, 28, 42, 'B'); put(px, 35, 42, 'B')
        put(px, 28, 43, 'B'); put(px, 35, 43, 'B')
        put(px, 27, 44, 'b'); put(px, 36, 44, 'b')
        put(px, 27, 45, 'b'); put(px, 36, 45, 'B')
        put(px, 27, 46, 'R'); put(px, 36, 46, 'b')
        put(px, 36, 47, 'R')

def draw_cheek_details(px, state):
    """Cheek bones, gauntness, scars."""
    # Gaunt cheek hollows
    for x in range(23, 27):
        put(px, x, 36, 's')
        put(px, x, 37, 's')
    for x in range(37, 41):
        put(px, x, 36, 's')
        put(px, x, 37, 's')
    put(px, 24, 38, 's')
    put(px, 39, 38, 's')
    # Cheekbone highlights
    put(px, 22, 34, 'E')
    put(px, 23, 34, 'E')
    put(px, 41, 33, 's')
    # Ritual scar on left cheek (inquisitor mark)
    put(px, 24, 39, 'T')
    put(px, 25, 40, 'T')
    put(px, 24, 41, 'T')

def draw_blood(px, state):
    """Progressive blood overlays."""
    if state >= 3:
        # Blood from brow (state 3+)
        put(px, 25, 24, 'B')
        put(px, 25, 25, 'B')
        put(px, 26, 26, 'B')
        put(px, 25, 27, 'b')
        put(px, 26, 28, 'b')
        put(px, 25, 29, 'B')
        # cut on brow
        put(px, 24, 23, 'B')
        put(px, 25, 23, 'B')
        put(px, 26, 23, 'R')
    if state >= 4:
        # Heavier bleeding: brow stream continues down face
        put(px, 24, 30, 'B')
        put(px, 24, 31, 'b')
        put(px, 24, 32, 'b')
        put(px, 23, 33, 'R')
        # Second cut on right cheek
        put(px, 38, 35, 'B')
        put(px, 39, 36, 'B')
        put(px, 39, 37, 'b')
        put(px, 40, 38, 'b')
        put(px, 40, 39, 'R')
        # Blood from nose
        put(px, 30, 36, 'B')
        put(px, 30, 37, 'b')
        put(px, 29, 38, 'R')
        # Forehead gash
        put(px, 33, 19, 'B')
        put(px, 34, 19, 'B')
        put(px, 35, 20, 'B')
        put(px, 36, 20, 'b')
        put(px, 36, 21, 'b')
        put(px, 37, 22, 'R')
    if state >= 5:
        # Critical: face covered in blood
        # Left side drenched
        for y in range(24, 34):
            put(px, 23, y, 'b')
            if y % 2 == 0:
                put(px, 22, y, 'R')
        put(px, 22, 34, 'R')
        put(px, 22, 35, 'b')
        put(px, 23, 35, 'B')
        # Right temple blood
        for y in range(20, 30):
            put(px, 40, y, 'b')
        put(px, 41, 22, 'R')
        put(px, 41, 24, 'B')
        put(px, 41, 26, 'b')
        # Blood in eyes region already handled; blood tears
        put(px, 26, 32, 'B')
        put(px, 26, 33, 'b')
        put(px, 37, 32, 'B')
        put(px, 37, 33, 'b')
        put(px, 26, 34, 'R')
        put(px, 37, 34, 'R')
        # Big forehead wound with corruption
        put(px, 30, 18, 'B')
        put(px, 31, 18, 'R')
        put(px, 32, 18, 'B')
        put(px, 31, 19, 'B')
        put(px, 30, 19, 'R')
        # Drips on chin
        put(px, 30, 46, 'b')
        put(px, 30, 47, 'R')
        put(px, 34, 46, 'B')
        put(px, 34, 47, 'b')

def draw_corruption(px, state):
    """Void corruption veins (states 4-5): purple veins spreading."""
    if state >= 4:
        # Veins on right side of face
        put(px, 39, 28, 'c')
        put(px, 40, 29, 'c')
        put(px, 40, 30, 'C')
        put(px, 41, 31, 'c')
        put(px, 41, 32, 'c')
        # vein on forehead
        put(px, 28, 20, 'c')
        put(px, 29, 21, 'c')
        put(px, 29, 22, 'C')
    if state >= 5:
        # Corruption spreads: neck, more of face
        put(px, 27, 21, 'c')
        put(px, 28, 22, 'C')
        put(px, 28, 23, 'c')
        # jaw corruption
        put(px, 38, 40, 'c')
        put(px, 39, 41, 'C')
        put(px, 39, 42, 'c')
        put(px, 40, 43, 'c')
        # neck veins
        put(px, 28, 47, 'c')
        put(px, 29, 48, 'C')
        put(px, 35, 47, 'c')
        put(px, 34, 48, 'C')
        # spectral glow spots in corruption (void seeping through)
        put(px, 29, 22, 'g')
        put(px, 39, 41, 'g')
        put(px, 40, 30, 'g')

def draw_state(state):
    """Build full portrait for damage state 1-5."""
    px = base_canvas()
    draw_hood(px)
    draw_gorget(px)
    draw_face_base(px)
    frown = {1: 0, 2: 1, 3: 2, 4: 2, 5: 2}[state]
    draw_brow(px, frown)
    draw_eyes(px, state)
    draw_nose(px)
    draw_cheek_details(px, state)
    draw_mouth(px, state)
    draw_blood(px, state)
    draw_corruption(px, state)
    return px

# ============================================================
# GENERATE
# ============================================================
OUT = os.path.dirname(os.path.abspath(__file__))
STATE_NAMES = {
    1: 'state1_healthy',
    2: 'state2_worried',
    3: 'state3_hurt',
    4: 'state4_critical',
    5: 'state5_dying',
}

frames = []
for s in range(1, 6):
    px = draw_state(s)
    frames.append(px)
    write_png(os.path.join(OUT, f'portrait_{STATE_NAMES[s]}.png'), px, W, H)
    # 2x upscale for preview
    up, uw, uh = upscale(px, W, H, 2)
    write_png(os.path.join(OUT, f'portrait_{STATE_NAMES[s]}_2x.png'), up, uw, uh)
    print(f'  ✓ portrait_{STATE_NAMES[s]}.png (64x64) + 2x')

# Sprite sheet: 5 frames horizontal, 64px each = 320x64
sheet = [[None]*(W*5) for _ in range(H)]
for i, px in enumerate(frames):
    for y in range(H):
        for x in range(W):
            sheet[y][i*W + x] = px[y][x]
write_png(os.path.join(OUT, 'portrait_spritesheet.png'), sheet, W*5, H)
print('  ✓ portrait_spritesheet.png (320x64, 5 frames)')

# 2x sheet
ups, uw, uh = upscale(sheet, W*5, H, 2)
write_png(os.path.join(OUT, 'portrait_spritesheet_2x.png'), ups, uw, uh)
print('  ✓ portrait_spritesheet_2x.png (640x128)')

print('\nDone. Files in:', OUT)
