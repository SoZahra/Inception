
// Attendre que le DOM soit chargé
document.addEventListener('DOMContentLoaded', function() {
    console.log('🚀 CV Site Statique - Inception Project loaded!');
    
    // Initialiser toutes les fonctionnalités
    initScrollAnimations();
    initSkillsInteraction();
    initProjectsInteraction();
    initTypingEffect();
    initThemeToggle();
    initStatsCounter();
});

// Animation au scroll
function initScrollAnimations() {
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);

    // Observer toutes les sections
    document.querySelectorAll('.section').forEach(section => {
        section.style.opacity = '0';
        section.style.transform = 'translateY(20px)';
        section.style.transition = 'all 0.6s ease-out';
        observer.observe(section);
    });
}

// Interaction avec les compétences
function initSkillsInteraction() {
    const skills = document.querySelectorAll('.skill');
    
    skills.forEach(skill => {
        // Effet de clic avec statistiques
        skill.addEventListener('click', function() {
            const skillName = this.textContent;
            showSkillInfo(skillName);
            
            // Animation de clic
            this.style.transform = 'scale(0.95)';
            setTimeout(() => {
                this.style.transform = 'scale(1)';
            }, 150);
        });

        // Effet hover amélioré
        skill.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-3px) scale(1.05)';
        });

        skill.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
        });
    });
}

// Afficher des infos sur les compétences
function showSkillInfo(skillName) {
    const skillsInfo = {
        'Docker': 'Containerisation et orchestration - Projet Inception',
        'NGINX': 'Serveur web haute performance - Configuration SSL/TLS',
        'MariaDB': 'Base de données relationnelle - Administration avancée',
        'WordPress': 'CMS - Installation et configuration avec PHP-FPM',
        'C': 'Programmation système - École 42',
        'JavaScript': 'Développement web frontend/backend',
        'Python': 'Scripts d\'automatisation et data science',
        'Linux': 'Administration système Unix/Linux'
    };

    const info = skillsInfo[skillName] || `Expertise en ${skillName}`;
    showToast(`${skillName}: ${info}`);
}

// Système de notifications toast
function showToast(message) {
    // Supprimer les toasts existants
    const existingToast = document.querySelector('.toast');
    if (existingToast) {
        existingToast.remove();
    }

    // Créer le toast
    const toast = document.createElement('div');
    toast.className = 'toast';
    toast.textContent = message;
    toast.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: linear-gradient(45deg, #3498db, #2980b9);
        color: white;
        padding: 15px 20px;
        border-radius: 10px;
        box-shadow: 0 5px 20px rgba(0,0,0,0.3);
        z-index: 1000;
        animation: slideInRight 0.3s ease-out;
        max-width: 300px;
        font-size: 0.9rem;
    `;

    document.body.appendChild(toast);

    // Supprimer après 3 secondes
    setTimeout(() => {
        toast.style.animation = 'slideOutRight 0.3s ease-out';
        setTimeout(() => toast.remove(), 300);
    }, 3000);
}

// Animation des projets
function initProjectsInteraction() {
    const projects = document.querySelectorAll('.project');
    
    projects.forEach((project, index) => {
        project.addEventListener('mouseenter', function() {
            this.style.transform = 'translateX(10px) scale(1.02)';
            this.style.boxShadow = '0 10px 30px rgba(52, 152, 219, 0.2)';
        });

        project.addEventListener('mouseleave', function() {
            this.style.transform = 'translateX(0) scale(1)';
            this.style.boxShadow = '0 5px 20px rgba(0, 0, 0, 0.1)';
        });

        // Animation d'apparition séquentielle
        setTimeout(() => {
            project.style.opacity = '1';
            project.style.transform = 'translateY(0)';
        }, index * 200);
        
        project.style.opacity = '0';
        project.style.transform = 'translateY(20px)';
        project.style.transition = 'all 0.5s ease-out';
    });
}

// Effet de frappe pour le titre
function initTypingEffect() {
    const title = document.querySelector('.header-info h1');
    if (title) {
        const originalText = title.textContent;
        title.textContent = '';
        
        let i = 0;
        const typeWriter = () => {
            if (i < originalText.length) {
                title.textContent += originalText.charAt(i);
                i++;
                setTimeout(typeWriter, 100);
            } else {
                // Ajouter un curseur clignotant
                const cursor = document.createElement('span');
                cursor.textContent = '|';
                cursor.style.animation = 'blink 1s infinite';
                title.appendChild(cursor);
            }
        };
        
        setTimeout(typeWriter, 500);
    }
}

// Toggle theme sombre/clair
function initThemeToggle() {
    // Créer le bouton de toggle
    const themeToggle = document.createElement('button');
    themeToggle.innerHTML = '🌙';
    themeToggle.style.cssText = `
        position: fixed;
        top: 20px;
        left: 20px;
        background: rgba(52, 152, 219, 0.9);
        color: white;
        border: none;
        border-radius: 50%;
        width: 50px;
        height: 50px;
        font-size: 1.5rem;
        cursor: pointer;
        z-index: 1000;
        transition: all 0.3s ease;
        box-shadow: 0 5px 15px rgba(0,0,0,0.2);
    `;

    themeToggle.addEventListener('click', function() {
        document.body.classList.toggle('dark-theme');
        this.innerHTML = document.body.classList.contains('dark-theme') ? '☀️' : '🌙';
        
        // Animation du bouton
        this.style.transform = 'scale(0.9)';
        setTimeout(() => {
            this.style.transform = 'scale(1)';
        }, 150);
    });

    document.body.appendChild(themeToggle);
}

// Compteur de statistiques animé
function initStatsCounter() {
    // Ajouter des stats en bas de page
    const footer = document.querySelector('.footer');
    const statsDiv = document.createElement('div');
    statsDiv.className = 'stats';
    statsDiv.innerHTML = `
        <div class="stat-item">
            <span class="stat-number" data-target="42">0</span>
            <span class="stat-label">École</span>
        </div>
        <div class="stat-item">
            <span class="stat-number" data-target="5">0</span>
            <span class="stat-label">Services Docker</span>
        </div>
        <div class="stat-item">
            <span class="stat-number" data-target="100">0</span>
            <span class="stat-label">% Fonctionnel</span>
        </div>
    `;
    
    statsDiv.style.cssText = `
        display: flex;
        justify-content: space-around;
        margin-top: 20px;
        padding: 20px 0;
        border-top: 1px solid rgba(255,255,255,0.2);
    `;

    footer.insertBefore(statsDiv, footer.firstChild);

    // Animation des chiffres
    const animateCounter = (element) => {
        const target = parseInt(element.dataset.target);
        const duration = 2000;
        const step = target / (duration / 16);
        let current = 0;

        const timer = setInterval(() => {
            current += step;
            if (current >= target) {
                current = target;
                clearInterval(timer);
            }
            element.textContent = Math.floor(current);
        }, 16);
    };

    // Observer pour déclencher l'animation
    const statsObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const counters = entry.target.querySelectorAll('.stat-number');
                counters.forEach(counter => animateCounter(counter));
                statsObserver.unobserve(entry.target);
            }
        });
    });

    statsObserver.observe(statsDiv);
}

// Ajouter les styles CSS pour les animations
const additionalStyles = `
    @keyframes slideInRight {
        from { transform: translateX(100%); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }
    
    @keyframes slideOutRight {
        from { transform: translateX(0); opacity: 1; }
        to { transform: translateX(100%); opacity: 0; }
    }
    
    @keyframes blink {
        0%, 50% { opacity: 1; }
        51%, 100% { opacity: 0; }
    }
    
    .dark-theme {
        background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%) !important;
    }
    
    .dark-theme .container {
        background: #2c3e50 !important;
        color: #ecf0f1 !important;
    }
    
    .stat-item {
        text-align: center;
    }
    
    .stat-number {
        display: block;
        font-size: 2rem;
        font-weight: bold;
        color: #3498db;
    }
    
    .stat-label {
        font-size: 0.9rem;
        opacity: 0.8;
    }
`;

// Ajouter les styles
const style = document.createElement('style');
style.textContent = additionalStyles;
document.head.appendChild(style);

// Easter egg - Konami Code
let konamiCode = ['ArrowUp', 'ArrowUp', 'ArrowDown', 'ArrowDown', 'ArrowLeft', 'ArrowRight', 'ArrowLeft', 'ArrowRight', 'KeyB', 'KeyA'];
let konamiIndex = 0;

document.addEventListener('keydown', function(e) {
    if (e.code === konamiCode[konamiIndex]) {
        konamiIndex++;
        if (konamiIndex === konamiCode.length) {
            showToast('🎉 Easter Egg! Inception Mode Activated! 🐳');
            document.body.style.animation = 'rainbow 2s infinite';
            konamiIndex = 0;
        }
    } else {
        konamiIndex = 0;
    }
});

console.log('💡 Tip: Essayez le Konami Code! ↑↑↓↓←→←→BA');
