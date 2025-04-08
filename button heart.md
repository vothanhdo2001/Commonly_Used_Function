```html
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Heart Animation</title>
  <style>
    body {
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      background: #f4f4f4;
    }

    .heart-wrapper {
      position: relative;
      cursor: pointer;
      width: 60px;
      height: 60px;
    }

    svg.heart {
      width: 100%;
      height: 100%;
      fill: transparent;
      stroke: black;
      stroke-width: 2;
      transition:
        stroke 0.6s ease,
        fill 0.1s ease;
    }

    svg.heart.animating {
      fill: #e91e63;
      stroke: #e91e63;
    }

    .floating-heart {
      position: absolute;
      width: 50px;
      height: 50px;
      fill: #e91e63;
      top: 0px;
      transform: translate(0%, 0) scale(1);
      animation: floatFree 1.4s ease-out forwards;
    }

    @keyframes floatFree {
      0% {
        opacity: 1;
        transform: translate(0, 0) scale(1);
      }
      30% {
        transform: translate(var(--x1, 0px), -40px) scale(1.3);
      }
      60% {
        transform: translate(var(--x2, 0px), -80px) scale(1.6);
      }
      100% {
        opacity: 0;
        transform: translate(var(--x3, 0px), -120px) scale(2);
      }
    }
  </style>
</head>
<body>

<div class="heart-wrapper" id="heartWrapper">
  <svg class="heart" id="mainHeart" viewBox="0 0 24 24">
    <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 
             2 5.42 4.42 3 7.5 3c1.74 0 3.41 0.81 4.5 2.09
             C13.09 3.81 14.76 3 16.5 3 
             19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54
             L12 21.35z"/>
  </svg>
</div>

<script>
  const wrapper = document.getElementById('heartWrapper');
  const mainHeart = document.getElementById('mainHeart');

  wrapper.addEventListener('click', () => {
    if (mainHeart.classList.contains('animating')) return;

    mainHeart.classList.add('animating');

    for (let i = 0; i < 6; i++) {
      const float = document.createElementNS("http://www.w3.org/2000/svg", "svg");
      float.setAttribute("viewBox", "0 0 24 24");
      float.classList.add('floating-heart');

      // Tạo độ lệch ngẫu nhiên trái/phải
      const offset1 = (Math.random() - 0.5) * 40;
      const offset2 = (Math.random() - 0.5) * 60;
      const offset3 = (Math.random() - 0.5) * 80;

      float.style.left = '10%';
      float.style.setProperty('--x1', `${offset1}px`);
      float.style.setProperty('--x2', `${offset2}px`);
      float.style.setProperty('--x3', `${offset3}px`);
      float.style.animationDelay = `${i * 0.1}s`;

      const path = document.createElementNS("http://www.w3.org/2000/svg", "path");
      path.setAttribute("d", "M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 \
        2 5.42 4.42 3 7.5 3c1.74 0 3.41 0.81 4.5 2.09\
        C13.09 3.81 14.76 3 16.5 3 \
        19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54\
        L12 21.35z");

      float.appendChild(path);
      wrapper.appendChild(float);

      setTimeout(() => {
        float.remove();
      }, 1600);
    }
  });
</script>

</body>
</html>
```
