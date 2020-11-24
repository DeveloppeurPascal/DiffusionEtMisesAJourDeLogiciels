object WebModule1: TWebModule1
  OldCreateOrder = False
  Actions = <
    item
      Default = True
      Name = 'DefaultHandler'
      PathInfo = '/'
      OnAction = WebModule1DefaultHandlerAction
    end
    item
      MethodType = mtGet
      Name = 'waGetLastRelease'
      PathInfo = '/GetLastRelease'
      OnAction = WebModule1waGetLastReleaseAction
    end>
  Height = 230
  Width = 415
end
