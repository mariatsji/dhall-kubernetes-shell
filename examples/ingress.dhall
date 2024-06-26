-- we find the dhall imported sha256 in the nix-shell via `dhall repl` and > :hash https://raw.githubusercontent.com/dhall-lang/dhall-lang/refs/tags/v22.0.0/Prelude/package.dhall
let Prelude =
        env:DHALLPRELUDE
          sha256:1c7622fdc868fe3a23462df3e6f533e50fdc12ecf3b42c0bb45c328ec8c4293e
      ? https://raw.githubusercontent.com/dhall-lang/dhall-lang/refs/tags/v22.0.0/Prelude/package.dhall
          sha256:1c7622fdc868fe3a23462df3e6f533e50fdc12ecf3b42c0bb45c328ec8c4293e

let map = Prelude.List.map

let kubernetes =
        env:DHALLKUB
          sha256:263ee915ef545f2d771fdcd5cfa4fbb7f62772a861b5c197f998e5b71219112c
      ? https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/package.dhall
          sha256:263ee915ef545f2d771fdcd5cfa4fbb7f62772a861b5c197f998e5b71219112c

let Service = { name : Text, host : Text, version : Text }

let services = [ { name = "foo", host = "foo.example.com", version = "2.3" } ]

let makeTLS
    : Service → kubernetes.IngressTLS.Type
    = λ(service : Service) →
        { hosts = Some [ service.host ]
        , secretName = Some "${service.name}-certificate"
        }

let makeRule
    : Service → kubernetes.IngressRule.Type
    = λ(service : Service) →
        { host = Some service.host
        , http = Some
          { paths =
            [ kubernetes.HTTPIngressPath::{
              , backend = kubernetes.IngressBackend::{
                , service = Some kubernetes.IngressServiceBackend::{
                  , name = service.name
                  , port = Some kubernetes.ServiceBackendPort::{
                    , number = Some 80
                    }
                  }
                }
              , pathType = "Exact"
              }
            ]
          }
        }

let mkIngress
    : List Service → kubernetes.Ingress.Type
    = λ(inputServices : List Service) →
        let annotations =
              toMap
                { `kubernetes.io/ingress.class` = "nginx"
                , `kubernetes.io/ingress.allow-http` = "false"
                }

        let defaultService =
              { name = "default"
              , host = "default.example.com"
              , version = " 1.0"
              }

        let ingressServices = inputServices # [ defaultService ]

        let spec =
              kubernetes.IngressSpec::{
              , tls = Some
                  ( map
                      Service
                      kubernetes.IngressTLS.Type
                      makeTLS
                      ingressServices
                  )
              , rules = Some
                  ( map
                      Service
                      kubernetes.IngressRule.Type
                      makeRule
                      ingressServices
                  )
              }

        in  kubernetes.Ingress::{
            , metadata = kubernetes.ObjectMeta::{
              , name = Some "nginx"
              , annotations = Some annotations
              }
            , spec = Some spec
            }

in  mkIngress services
