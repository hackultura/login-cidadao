<?php

namespace PROCERGS\LoginCidadao\CoreBundle\EventListener;

use PROCERGS\LoginCidadao\CoreBundle\Security\Exception\AlreadyLinkedAccount;
use Symfony\Component\HttpFoundation\Session\SessionInterface;
use Symfony\Component\HttpKernel\Event\GetResponseForExceptionEvent;
use Symfony\Component\HttpKernel\Exception\HttpExceptionInterface;
use Symfony\Component\Routing\RouterInterface;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\Translation\TranslatorInterface;

class ExceptionListener
{

    private $session;
    private $router;
    private $translator;

    public function __construct(SessionInterface $session, RouterInterface $router, TranslatorInterface $translator)
    {
        $this->session = $session;
        $this->router = $router;
        $this->translator = $translator;
    }

    public function onKernelException(GetResponseForExceptionEvent $event)
    {
        $exception = $event->getException();
        if ($exception instanceof AlreadyLinkedAccount) {
            $this->session->getFlashBag()->add(
                'error',
                $this->translator->trans($exception->getMessage())
            );
            $url = $this->router->generate('fos_user_profile_edit');
            $event->setResponse(new RedirectResponse($url));
        }
    }
}
