
var Emoji_Insert_Cooldown = {}
async function ToggleEmoji(id) {
    if (Emoji_Insert_Cooldown[id] == true) { return; }
    Emoji_Insert_Cooldown[id] = true;
    await $.ajax({
        url: 'Message.aspx/ToggleEmoji',
        type: 'POST',
        contentType: 'application/json',
        dataType: 'json',
        data: `{ "Message_Id": ${ellips.attr("Message_Id")},"Emoji_Id": ${parseInt(id.match(/\d+/))}}`,
        success: function (response) {


        },
        error: function (xhr, status, error) {
            // Handle any errors
            console.error(error);
        }
    });
    Emoji_Insert_Cooldown[id] = false;
}


$(".Emoji").on("click", function (e) {
    var id = $(e.target).attr("id")
    
    if (id.includes("Emoji_")) {
        ToggleEmoji(id);

    }
})

var lastindexednum = 0;





function getRandomNumberBetween(min, max) {
    return Math.random() * (max - min) + min;
}

class Particle {
    constructor(x, y, speedX, speedY, emoji) {
        this.x = x;
        this.y = y;
        this.speedX = speedX;
        this.speedY = speedY;
        this.emoji = emoji;
        this.size = 30; // Adjust the size of the emoji particles here
    }

    update(canvas) {
        this.x += this.speedX;
        this.y += this.speedY;

        // If particles move off the canvas, reset their position to the opposite side
        if (this.x < 0) this.x = canvas.width;
        if (this.x > canvas.width) this.x = 0;
        if (this.y < 0) this.y = canvas.height;
        if (this.y > canvas.height) this.y = 0;
    }

    draw(ctx) {
        ctx.textBaseline = "middle";
        ctx.font = `${this.size}px serif`;
        ctx.fillText(this.emoji, this.x, this.y);
    }
}

function createParticle(canvas, particles) {
    const x = canvas.width / 2;
    const y = canvas.height / 2;
    const speedX = getRandomNumberBetween(-10, 10);
    const speedY = getRandomNumberBetween(-10, 10);

    // Replace '😃' with any other emoji you want to use
    const emoji = '😃';

    const particle = new Particle(x, y, speedX, speedY, emoji);
    particles.push(particle);
}

function updateParticles(canvas, particles) {
    for (const particle of particles) {
        particle.update(canvas);
    }
}

function drawParticles(canvas, particles) {
  
    const ctx = canvas.getContext("2d");
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    for (const particle of particles) {
        particle.draw(ctx);
    }
}

function particleAnimate(canvas) {
        const particles = [];
    createParticle(canvas, particles);
    updateParticles(canvas, particles);
    drawParticles(canvas, particles);



    var dur = 100;

    var update = function () {
        updateParticles(canvas, particles);
        drawParticles(canvas, particles);
        dur -= 1;
        if (dur > 1) {
     
            setTimeout(update, 100);    
        }
    }

    update();

}

