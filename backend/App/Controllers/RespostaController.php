<?php 

namespace App\Controllers;

use App\DAO\MySQL\RespostaDAO;
use App\Models\MySQL\RespostaModel;

use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;

use Psr\Http\UploadedFile;

class RespostaController
{
    public function buscaRespostas(Request $request, Response $response, array $args): Response
    {
        $respostaDAO = new RespostaDAO();
        $resposta = $respostaDAO->buscaPessoaRespostas();

        foreach($resposta as $data){
            $resposta= $data;

            $respostaPergunta= $respostaDAO->buscaPessoaRespostaPergunta($data['codigo']);

            foreach($respostaPergunta as $datarespostaPergunta){
                $perguntaTipoResposta = $respostaDAO->buscaPessoaRespostaPerguntaParamentro($data['codigo'],$datarespostaPergunta['codigo']);
                
                $datarespostaPergunta['parametros'] = $perguntaTipoResposta;
                $PerguntaTipoParametroBD = $datarespostaPergunta;

                $data['pergunta'][] = $PerguntaTipoParametroBD;

            }

            $resposta= $data;
            $resultado['respostas'][] = $resposta; 

        }

        $response = $response->withjson($resultado);

        return $response;
    }

    public function insereResposta(Request $request, Response $response, array $args): Response
    {
        $data = $request->getParsedBody();

        $imagem = $request->getUploadedFiles();

        $respostaDAO = new RespostaDAO();
        $resposta = new RespostaModel();

        $respostas = $data['respostas'];

        $pergunta = $respostas['perguntas'];
    
        foreach($pergunta as $dataPergunta){
            $parametros = $dataPergunta['parametros'];

            foreach($parametros as $dataParametros){
                $parametro = $dataParametros;

                $resposta
                    ->setCodigoPessoa($respostas['codigoPessoa'])
                    ->setCodigoPergunta($dataPergunta['codigo'])
                    ->setEscolhaUnica($parametro['escolhaUnica'])
                    ->setEscolhaMultipla($parametro['escolhaMultipla'])
                    ->setTexto($parametro['texto'])
                    ->setNumero($parametro['numero'])
                    ->setData($parametro['data'])
                    ->setArquivo($parametro['arquivo']);

                    // var_dump($resposta);
                
                $respostaDAO->insereResposta($resposta);
            }

        }

        $response = $response->withjson([
            "message" => "Cadastro realizado"
        ]);

        return $response;
    }

    public function insereRespostaImagem(Request $request, Response $response, array $args): Response
    {

        $imagem = $request->getUploadedFiles();

        // $imagems = $imagem['imagem'];

        $pasta = "arquivos/";
                    
        if (!file_exists($pasta)){
            mkdir("$pasta", 0777);
        }

       $diretorio = "./../arquivos";

    //    $arquivo = $imagems;

    //    $uploadedFile = $imagem['imagem'];
       
 
        $newfile = $imagem['imagem'];

        // if ($newfile->getError() === UPLOAD_ERR_OK) {
        //     $uploadFileName = $newfile->getClientFilename();

        //     var_dump($uploadFileName);
        //     $newfile->moveTo("../arquivo/$uploadFileName");
        // }

        $uploadFileName = $newfile->getClientFilename();
        $arquivo = $uploadFileName;

       for($controle = 0; $controle < count($arquivo); $controle++){
           $destino = $diretorio."/".$controle.".png";
           if(move_uploaded_file($uploadFileName.$controle, $destino)){
               printf('Upload Concluido');
           }else{
               printf( 'Falha no Upload');
           }
       }

        $response = $response->withjson($uploadFileName);

        return $response;
    }

    // public function moveUploadedFile($directory, UploadedFile $uploadedFile)
    // {
    //     $extension = pathinfo($uploadedFile->getClientFilename(), PATHINFO_EXTENSION);
    //     $basename = bin2hex(random_bytes(8)); // see http://php.net/manual/en/function.random-bytes.php
    //     $filename = sprintf('%s.%0.8s', $basename, $extension);

    //     $uploadedFile->moveTo($directory . DIRECTORY_SEPARATOR . $filename);

    //     return $filename;
    // }

}