#!/usr/bin/env python3
"""
Portrait SVG Generator — Whispering Corridors
Inquisidor del Vacío: 5 damage states, 64x64 pixel art.
Generates SVG files with crispEdges (1 rect per pixel) for later PNG conversion.
"""
import os

PAL = {
    'K': '#0A0510', 'H': '#1A1025', 'h': '#2A1A38', 'P': '#3E2850', 'p': '#583A6E',
    'S': '#C9B29B', 's': '#AB917A', 'D': '#8A705C', 'd': '#695242', 'E': '#DECDBA',
    'G': '#39FF8D', 'g': '#1EB464', 'V': '#106E3E', 'v': '#083C22',
    'B': '#A4161A', 'b': '#750C12', 'R': '#4A060C',
    'C': '#5E2A84', 'c': '#381652',
    'W': '#E6E0D2', 'w': '#B4AC9B',
    'Y': '#D6D2B4',
    'M': '#787682', 'm': '#464452', 'L': '#AAA8B2',
    'T': '#5A3C37',
}

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
    for y in range(0, 20):
        half = 8 + y
        cx = 32
        for x in range(cx-half, cx+half+1):
            put(px, x, y, 'K')
    for y in range(20, 52):
        for x in range(0, 14):
            put(px, x, y, 'K')
        for x in range(50, 64):
            put(px, x, y, 'K')
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
    for y in range(8, 44):
        put(px, 12, y, 'h')
        put(px, 13, y, 'h')
    for y in range(10, 30):
        put(px, 11, y, 'h')
    for y in range(8, 44):
        put(px, 51, y, 'h')
        put(px, 52, y, 'h')
    for y in range(52, 64):
        for x in range(0, 64):
            put(px, x, y, 'K')
    for y in range(54, 64):
        for x in range(4, 60):
            put(px, x, y, 'H')
    for y in range(56, 64):
        for x in range(8, 56):
            put(px, x, y, 'h')

def draw_gorget(px):
    for y in range(50, 56):
        for x in range(22, 42):
            put(px, x, y, 'm')
    for y in range(50, 53):
        for x in range(24, 40):
            put(px, x, y, 'M')
    fill_rect(px, 30, 51, 33, 54, 'V')
    put(px, 31, 52, 'g')
    put(px, 32, 52, 'g')
    put(px, 31, 53, 'V')
    put(px, 32, 53, 'V')
    put(px, 24, 51, 'L')
    put(px, 39, 51, 'L')

def draw_face_base(px):
    rows = [
        (16, 26, 37), (17, 24, 39), (18, 23, 40), (19, 22, 41),
        (20, 21, 42), (21, 21, 42), (22, 20, 43), (23, 20, 43),
        (24, 20, 43), (25, 20, 43), (26, 20, 43), (27, 20, 43),
        (28, 20, 43), (29, 20, 43), (30, 20, 43), (31, 20, 43),
        (32, 20, 43), (33, 20, 43), (34, 20, 43), (35, 20, 43),
        (36, 20, 43), (37, 21, 42), (38, 21, 42), (39, 21, 42),
        (40, 22, 41), (41, 22, 41), (42, 23, 40), (43, 23, 40),
        (44, 24, 39), (45, 24, 39), (46, 25, 38), (47, 26, 37),
        (48, 27, 36), (49, 28, 35), (50, 29, 34),
    ]
    for y, x0, x1 in rows:
        for x in range(x0, x1+1):
            put(px, x, y, 'S')
    for y, x0, x1 in rows:
        w = x1 - x0
        sh = max(1, w // 3)
        for x in range(x1-sh+1, x1+1):
            put(px, x, y, 's')
        put(px, x1, y, 'D')
    for y, x0, x1 in rows:
        if 20 <= y <= 44:
            put(px, x0, y, 'E')
            if y < 40:
                put(px, x0+1, y, 'E')
    for y in range(42, 51):
        for x in range(24, 40):
            if px[y][x] == 'S':
                put(px, x, y, 's')
    for x in range(28, 36):
        put(px, x, 49, 'D')
        put(px, x, 50, 'D')

def draw_brow(px, frown=0):
    for x in range(23, 41):
        put(px, x, 26, 'D')
    if frown == 0:
        for x in range(24, 29):
            put(px, x, 25, 'd')
        for x in range(35, 40):
            put(px, x, 25, 'd')
    elif frown == 1:
        for x in range(24, 29):
            put(px, x, 25, 'd')
        for x in range(35, 40):
            put(px, x, 25, 'd')
        put(px, 28, 26, 'd')
        put(px, 35, 26, 'd')
        put(px, 31, 22, 's')
        put(px, 32, 22, 's')
        put(px, 31, 23, 's')
        put(px, 32, 23, 's')
    else:
        for x in range(24, 29):
            put(px, x, 24 + (28-x)//3, 'd')
        for x in range(35, 40):
            put(px, x, 24 + (x-35)//3, 'd')
        put(px, 29, 26, 'd')
        put(px, 34, 26, 'd')
        for x in range(29, 35):
            put(px, x, 21, 's')
            put(px, x, 23, 's')
        put(px, 31, 22, 'D')
        put(px, 32, 22, 'D')

def draw_eyes(px, state):
    fill_rect(px, 24, 28, 29, 31, 'd')
    fill_rect(px, 34, 28, 39, 31, 'd')
    fill_rect(px, 25, 29, 28, 30, 'Y')
    fill_rect(px, 35, 29, 38, 30, 'Y')
    if state == 1:
        put(px, 27, 29, 'V'); put(px, 27, 30, 'g')
        put(px, 36, 29, 'V'); put(px, 36, 30, 'g')
    elif state == 2:
        put(px, 26, 29, 'g'); put(px, 27, 29, 'g')
        put(px, 26, 30, 'V'); put(px, 27, 30, 'V')
        put(px, 36, 29, 'g'); put(px, 37, 29, 'g')
        put(px, 36, 30, 'V'); put(px, 37, 30, 'V')
    elif state == 3:
        put(px, 25, 30, 's')
        put(px, 26, 30, 's')
        put(px, 27, 29, 'g')
        put(px, 36, 29, 'G'); put(px, 37, 29, 'g')
        put(px, 36, 30, 'g'); put(px, 37, 30, 'V')
        put(px, 35, 29, 'B')
        put(px, 38, 30, 'B')
    elif state == 4:
        fill_rect(px, 25, 28, 28, 31, 'Y')
        fill_rect(px, 35, 28, 38, 31, 'Y')
        put(px, 26, 29, 'G'); put(px, 27, 29, 'G')
        put(px, 26, 30, 'g'); put(px, 27, 30, 'g')
        put(px, 36, 29, 'G'); put(px, 37, 29, 'G')
        put(px, 36, 30, 'g'); put(px, 37, 30, 'g')
        put(px, 25, 28, 'B'); put(px, 28, 31, 'B')
        put(px, 38, 28, 'B'); put(px, 35, 31, 'B')
        for x in range(25, 29):
            put(px, x, 32, 'c')
        for x in range(35, 39):
            put(px, x, 32, 'c')
    else:
        fill_rect(px, 25, 28, 28, 31, 'v')
        fill_rect(px, 35, 28, 38, 31, 'v')
        put(px, 26, 29, 'G'); put(px, 27, 29, 'G')
        put(px, 26, 30, 'G'); put(px, 27, 30, 'G')
        put(px, 36, 29, 'G'); put(px, 37, 29, 'G')
        put(px, 36, 30, 'G'); put(px, 37, 30, 'G')
        put(px, 25, 28, 'g'); put(px, 28, 28, 'g')
        put(px, 35, 28, 'g'); put(px, 38, 28, 'g')
        put(px, 24, 29, 'V'); put(px, 29, 29, 'V')
        put(px, 34, 29, 'V'); put(px, 39, 29, 'V')
        for x in range(24, 30):
            put(px, x, 32, 'c')
            put(px, x, 33, 'C')
        for x in range(34, 40):
            put(px, x, 32, 'c')
            put(px, x, 33, 'C')

def draw_nose(px):
    put(px, 31, 32, 's'); put(px, 32, 32, 's')
    put(px, 31, 33, 's'); put(px, 32, 33, 's')
    put(px, 30, 34, 's'); put(px, 31, 34, 'D')
    put(px, 32, 34, 'D'); put(px, 33, 34, 's')
    put(px, 30, 35, 'd'); put(px, 33, 35, 'd')
    put(px, 31, 35, 's'); put(px, 32, 35, 's')
    put(px, 31, 31, 'E')

def draw_mouth(px, state):
    if state == 1:
        for x in range(28, 36):
            put(px, x, 41, 'd')
        put(px, 27, 41, 's'); put(px, 36, 41, 's')
        put(px, 28, 42, 's'); put(px, 35, 42, 's')
    elif state == 2:
        for x in range(28, 36):
            put(px, x, 41, 'd')
        put(px, 27, 42, 'd'); put(px, 36, 42, 'd')
        put(px, 28, 42, 's'); put(px, 35, 42, 's')
    elif state == 3:
        for x in range(27, 37):
            put(px, x, 40, 'd')
        for x in range(28, 36):
            put(px, x, 41, 'W')
        put(px, 30, 41, 'w'); put(px, 32, 41, 'w'); put(px, 34, 41, 'w')
        for x in range(28, 36):
            put(px, x, 42, 'd')
    elif state == 4:
        for x in range(27, 37):
            put(px, x, 40, 'd')
        for x in range(28, 36):
            put(px, x, 41, 'W')
            put(px, x, 42, 'w')
        put(px, 30, 41, 'd'); put(px, 32, 41, 'd'); put(px, 34, 41, 'd')
        put(px, 30, 42, 'd'); put(px, 32, 42, 'd'); put(px, 34, 42, 'd')
        for x in range(28, 36):
            put(px, x, 43, 'd')
        put(px, 37, 42, 'B'); put(px, 37, 43, 'B')
        put(px, 38, 44, 'b'); put(px, 38, 45, 'b')
    else:
        for x in range(27, 37):
            put(px, x, 40, 'd')
        for x in range(28, 36):
            put(px, x, 41, 'W')
        put(px, 30, 41, 'd'); put(px, 32, 41, 'd'); put(px, 34, 41, 'd')
        for x in range(29, 35):
            put(px, x, 42, 'K')
            put(px, x, 43, 'K')
        put(px, 30, 44, 'K'); put(px, 33, 44, 'K')
        put(px, 31, 44, 'R'); put(px, 32, 44, 'R')
        for x in range(28, 36):
            put(px, x, 45, 'd')
        put(px, 28, 42, 'B'); put(px, 35, 42, 'B')
        put(px, 28, 43, 'B'); put(px, 35, 43, 'B')
        put(px, 27, 44, 'b'); put(px, 36, 44, 'b')
        put(px, 27, 45, 'b'); put(px, 36, 45, 'B')
        put(px, 27, 46, 'R'); put(px, 36, 46, 'b')
        put(px, 36, 47, 'R')

def draw_cheek_details(px, state):
    for x in range(23, 27):
        put(px, x, 36, 's')
        put(px, x, 37, 's')
    for x in range(37, 41):
        put(px, x, 36, 's')
        put(px, x, 37, 's')
    put(px, 24, 38, 's')
    put(px, 39, 38, 's')
    put(px, 22, 34, 'E')
    put(px, 23, 34, 'E')
    put(px, 41, 33, 's')
    put(px, 24, 39, 'T')
    put(px, 25, 40, 'T')
    put(px, 24, 41, 'T')

def draw_blood(px, state):
    if state >= 3:
        put(px, 25, 24, 'B'); put(px, 25, 25, 'B')
        put(px, 26, 26, 'B'); put(px, 25, 27, 'b')
        put(px, 26, 28, 'b'); put(px, 25, 29, 'B')
        put(px, 24, 23, 'B'); put(px, 25, 23, 'B')
        put(px, 26, 23, 'R')
    if state >= 4:
        put(px, 24, 30, 'B'); put(px, 24, 31, 'b')
        put(px, 24, 32, 'b'); put(px, 23, 33, 'R')
        put(px, 38, 35, 'B'); put(px, 39, 36, 'B')
        put(px, 39, 37, 'b'); put(px, 40, 38, 'b')
        put(px, 40, 39, 'R')
        put(px, 30, 36, 'B'); put(px, 30, 37, 'b')
        put(px, 29, 38, 'R')
        put(px, 33, 19, 'B'); put(px, 34, 19, 'B')
        put(px, 35, 20, 'B'); put(px, 36, 20, 'b')
        put(px, 36, 21, 'b'); put(px, 37, 22, 'R')
    if state >= 5:
        for y in range(24, 34):
            put(px, 23, y, 'b')
            if y % 2 == 0:
                put(px, 22, y, 'R')
        put(px, 22, 34, 'R'); put(px, 22, 35, 'b')
        put(px, 23, 35, 'B')
        for y in range(20, 30):
            put(px, 40, y, 'b')
        put(px, 41, 22, 'R'); put(px, 41, 24, 'B')
        put(px, 41, 26, 'b')
        put(px, 26, 32, 'B'); put(px, 26, 33, 'b')
        put(px, 37, 32, 'B'); put(px, 37, 33, 'b')
        put(px, 26, 34, 'R'); put(px, 37, 34, 'R')
        put(px, 30, 18, 'B'); put(px, 31, 18, 'R')
        put(px, 32, 18, 'B'); put(px, 31, 19, 'B')
        put(px, 30, 19, 'R')
        put(px, 30, 46, 'b'); put(px, 30, 47, 'R')
        put(px, 34, 46, 'B'); put(px, 34, 47, 'b')

def draw_corruption(px, state):
    if state >= 4:
        put(px, 39, 28, 'c'); put(px, 40, 29, 'c')
        put(px, 40, 30, 'C'); put(px, 41, 31, 'c')
        put(px, 41, 32, 'c')
        put(px, 28, 20, 'c'); put(px, 29, 21, 'c')
        put(px, 29, 22, 'C')
    if state >= 5:
        put(px, 27, 21, 'c'); put(px, 28, 22, 'C')
        put(px, 28, 23, 'c')
        put(px, 38, 40, 'c'); put(px, 39, 41, 'C')
        put(px, 39, 42, 'c'); put(px, 40, 43, 'c')
        put(px, 28, 47, 'c'); put(px, 29, 48, 'C')
        put(px, 35, 47, 'c'); put(px, 34, 48, 'C')
        put(px, 29, 22, 'g'); put(px, 39, 41, 'g')
        put(px, 40, 30, 'g')

def draw_state(state):
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

def px_to_svg(px, scale=1):
    """Convert pixel grid to SVG with merged runs per row for compactness."""
    rects = []
    for y in range(H):
        x = 0
        while x < W:
            c = px[y][x]
            if c is None:
                x += 1
                continue
            x0 = x
            while x < W and px[y][x] == c:
                x += 1
            rects.append(f'<rect x="{x0*scale}" y="{y*scale}" width="{(x-x0)*scale}" height="{scale}" fill="{PAL[c]}"/>')
    return (f'<svg xmlns="http://www.w3.org/2000/svg" width="{W*scale}" height="{H*scale}" '
            f'viewBox="0 0 {W*scale} {H*scale}" shape-rendering="crispEdges">'
            + ''.join(rects) + '</svg>')

def sheet_to_svg(frames, scale=1):
    rects = []
    for i, px in enumerate(frames):
        ox = i * W
        for y in range(H):
            x = 0
            while x < W:
                c = px[y][x]
                if c is None:
                    x += 1
                    continue
                x0 = x
                while x < W and px[y][x] == c:
                    x += 1
                rects.append(f'<rect x="{(ox+x0)*scale}" y="{y*scale}" width="{(x-x0)*scale}" height="{scale}" fill="{PAL[c]}"/>')
    return (f'<svg xmlns="http://www.w3.org/2000/svg" width="{W*5*scale}" height="{H*scale}" '
            f'viewBox="0 0 {W*5*scale} {H*scale}" shape-rendering="crispEdges">'
            + ''.join(rects) + '</svg>')

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
    with open(os.path.join(OUT, f'portrait_{STATE_NAMES[s]}.svg'), 'w') as f:
        f.write(px_to_svg(px, 1))
    with open(os.path.join(OUT, f'portrait_{STATE_NAMES[s]}_4x.svg'), 'w') as f:
        f.write(px_to_svg(px, 4))
    print(f'  portrait_{STATE_NAMES[s]}.svg')

with open(os.path.join(OUT, 'portrait_spritesheet.svg'), 'w') as f:
    f.write(sheet_to_svg(frames, 1))
with open(os.path.join(OUT, 'portrait_spritesheet_4x.svg'), 'w') as f:
    f.write(sheet_to_svg(frames, 4))
print('  portrait_spritesheet.svg (5 frames)')
print('Done.')
