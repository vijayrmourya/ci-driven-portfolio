// scripts.js
(function(){
  // highlight nav link based on file name
  const path = location.pathname.split('/').pop() || 'index.html';
  document.querySelectorAll('.nav a').forEach(a=>{
    if (a.getAttribute('href') === path) a.classList.add('active');
  });
  // mobile select handler (if present)
  const sel = document.getElementById('mobile-nav');
  if (sel) sel.addEventListener('change', e => {
    if (e.target.value) location.href = e.target.value;
  });
})();
