$(document).ready(function() {
  console.log( "ready!" );
  $(".nuestra_empresa").hover(function(){
    $(".nuestra_empresa h1").css("display","none");
    $(".nuestra_empresa p").css("display","block");

  }, function(){
    $(".nuestra_empresa h1").css("display","block");
    $(".nuestra_empresa p").css("display","none");

  })

  $(".quienes_somos").hover(function(){
    $(".quienes_somos h1").css("display","none");
    $(".quienes_somos p").css("display","block");

  }, function(){
    $(".quienes_somos h1").css("display","block");
    $(".quienes_somos p").css("display","none");

  })
})