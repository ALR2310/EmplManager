/* Shapes */
var svgContainer = document.getElementById('svgContainer');
var animItem = bodymovin.loadAnimation({
    wrapper: svgContainer,
    animType: 'svg',
    loop: true,
    path: 'https://dev.anthonyfessy.com/check.json'
});