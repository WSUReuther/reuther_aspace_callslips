$(function () {
  var add_call_slip_button = function () {
    var $toolbar = $(".record-toolbar > .btn-toolbar > .btn-group");
    var $call_slip_button = $("<div class='btn-group'><a id='callSlip' class='btn btn-sm btn-default'>Add Callslip</a></div>");
    $toolbar.prepend($call_slip_button);
    $toolbar.on("click", "#callSlip", add_call_slip);
  };

  var add_call_slip = function () {
    var $object_uri = $("#uri").attr("value");
    $.ajax({
      url: AS.app_prefix("/plugins/call_slips/generate"),
      data: {
        object_uri: $object_uri
      },
      type: "POST",
      success: function (call_slip_url) {
        window.open(call_slip_url);
      },
    })
  };

  $(document).on('loadedrecordform.aspace', function () {
    add_call_slip_button();
  });
});