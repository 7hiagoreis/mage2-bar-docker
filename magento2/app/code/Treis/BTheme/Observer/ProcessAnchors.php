<?php
namespace Treis\BTheme\Observer;

use Magento\Framework\Event\Observer;
use Magento\Framework\Event\ObserverInterface;
use Magento\Framework\View\LayoutInterface;

class ProcessAnchors implements ObserverInterface
{
    /**
     * @var LayoutInterface
     */
    protected $_layout;

    /**
     * @param LayoutInterface $layout
     */
    public function __construct(
        LayoutInterface $layout
    ) {
        $this->_layout = $layout;
    }

    /**
     * Execute observer
     *
     * @param Observer $observer
     * @return void
     */
    public function execute(Observer $observer)
    {
        // Verifica se é uma página CMS
        $handles = $this->_layout->getUpdate()->getHandles();
        if (!in_array('cms_page_view', $handles)) {
            return;
        }

        // Adiciona o container para o layout
        $this->_layout->addContainer(
            'anchors_container',
            'Anchors Container',
            [],
            'content'
        );

        // Adiciona o bloco dinâmico
        $this->_layout->addBlock(
            \Magento\Framework\View\Element\Template::class,
            'dynamic_anchors_block',
            'anchors_container',
            [
                'template' => 'TReis_BTheme::dynamic_anchors.phtml',
                'cacheable' => false
            ]
        );
    }
}
