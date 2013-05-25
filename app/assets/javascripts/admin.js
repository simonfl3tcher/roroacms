$(document).ready(function(){
  
  $('.redactor').redactor({ 
  	buttons: ['html', '|', 'formatting', '|', 'bold', 'italic', 'deleted', 'underline', '|',
'unorderedlist', 'orderedlist', 'outdent', 'indent', '|', 'alignleft', 'aligncenter', 'alignright', '|',
'image', 'video', 'file', 'table', 'link', '|',
'fontcolor', 'backcolor', '|', 'horizontalrule'],
  	imageUpload: '/admin/upload', 
  	imageUpload: '/admin/upload' 
  }); 
 
});