const level = new Vue({
    el: '.section-lvlup',
    data: {
        active: false,
        currentLevel: 1,
        progress: 0,
        maxProgress: 25,
        animationSpeed: 100,
    },
    computed: {
        nextLevel() {
            return this.currentLevel + 1;
        }
    },
    methods: {
        async levelUp(totalXP) {
            this.active = true;
            
            const newLevel = Math.floor(totalXP / this.maxProgress) + 1;
            const newProgress = totalXP % this.maxProgress;
            
            while (this.currentLevel < newLevel) {
                for (let i = this.progress; i <= this.maxProgress; i++) {
                    this.progress = i;
                    await new Promise(resolve => setTimeout(resolve, this.animationSpeed));
                }
                
                await new Promise(resolve => setTimeout(resolve, 500));
                this.currentLevel++;
                this.progress = 0;
                await new Promise(resolve => setTimeout(resolve, 500));
            }
            
            for (let i = this.progress; i <= newProgress; i++) {
                this.progress = i;
                await new Promise(resolve => setTimeout(resolve, this.animationSpeed));
            }
            
            setTimeout(() => {
                this.active = false;
            }, 2000);
        },

        onMessage(event) {
            const { interface: ui, action, xp } = event.data;

            if (ui === 'lvl' && action === 'lvlup') {
                this.levelUp(xp);
            }
        }
    },
    mounted() {
        window.addEventListener('message', this.onMessage);
    },
});