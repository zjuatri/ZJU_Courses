function plotAFMdata(H, F, I, ss, saveName)
    fig = figure('Position', [0, 0, 1000, 460], 'Color', 'w', 'PaperPositionMode', 'auto');
    
    subplot(2, 2, 1);
    surf(H, F, 'EdgeColor', 'none');
    title('Friction overlaid height');
    grid off;
    xlabel('nm','FontSize', 10, 'FontName', 'Arial');
    ylabel('nm','FontSize', 10, 'FontName', 'Arial');
    zlabel('nm','FontSize', 10, 'FontName', 'Arial');
    cb1=colorbar;
    title(cb1,'Friction (mV)','FontSize', 10, 'FontName', 'Arial')
    box on;
    set(gca,'BoxStyle','full');
    axis tight
    xlim([0 ss])
    ylim([0 ss])
    view(-45, 50)
    
 
    subplot(2, 2, 2);
    surf(H, I, 'EdgeColor', 'none');
    title('Current overlaid height','FontSize', 10, 'FontName', 'Arial');
    grid off;
    xlabel('nm','FontSize', 10, 'FontName', 'Arial');
    ylabel('nm','FontSize', 10, 'FontName', 'Arial');
    zlabel('nm','FontSize', 10, 'FontName', 'Arial');
    cb2 = colorbar;
    title(cb2,'Current Response (V)','FontSize', 10, 'FontName', 'Arial')
    box on;
    set(gca,'BoxStyle','full');
    axis tight
    xlim([0 ss])
    ylim([0 ss])
    view(-45, 50)

    

    subplot(2, 2, 3);
    scatter(F, I, 'k.');
    title('Current as a function of friction','FontSize', 10, 'FontName', 'Arial');
    xlabel('Friction (mV)','FontSize', 10, 'FontName', 'Arial');
    ylabel('Current Response (V)','FontSize', 10, 'FontName', 'Arial');
    

    subplot(2, 2, 4);
    histogram(I, -1:0.1:7);
    title('Current histogram','FontSize', 10, 'FontName', 'Arial');
    xlabel('Current Response (V)','FontSize', 10, 'FontName', 'Arial');
    ylabel('Counts','FontSize', 10, 'FontName', 'Arial');

    movegui(fig,"center");
    

    saveas(fig, saveName, 'jpeg');
    exportgraphics(fig,saveName,'Resolution',300)
    
end