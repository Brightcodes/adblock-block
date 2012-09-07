package {

    // Catches an error that will occur if the Ad module swf has been blocked
    // Uses overlay API to put annoying text in front of player for those blocking ads
    // Implement as a required module in BEML to ensure that it is loaded

    import com.brightcove.api.APIModules;
    import com.brightcove.api.BrightcoveModuleWrapper;
    import com.brightcove.api.events.ExperienceEvent;
    import com.brightcove.api.modules.ExperienceModule;
    import com.brightcove.api.modules.AdvertisingModule;
    import com.brightcove.api.modules.VideoPlayerModule;
    import flash.display.Sprite;
    import flash.events.IEventDispatcher;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFieldAutoSize;
    public class Module extends Sprite {

        private
        var _player: BrightcoveModuleWrapper;
        private
        var _experienceModule: ExperienceModule;

        private
        function initialize(): void {


        }

        private
        function checkReady(): void {
            if (_experienceModule.getReady()) {
                initialize();
            } else {
                _experienceModule.addEventListener(ExperienceEvent.TEMPLATE_READY, onTemplateReady);
            }
        }

        private
        function onTemplateReady(event: ExperienceEvent): void {
            _experienceModule.removeEventListener(ExperienceEvent.TEMPLATE_READY, onTemplateReady);
            var _adModule: AdvertisingModule = _player.getModule(APIModules.ADVERTISING) as AdvertisingModule;
            try {
                _adModule.getCurrentAdTranslator();
            } catch (e: Error) {
				// No ad module was loaded, so do things here
                var videoPlayer: VideoPlayerModule = _player.getModule(APIModules.VIDEO_PLAYER) as VideoPlayerModule;
                var _overlay: Sprite;
                _overlay = videoPlayer.overlay();
                var blockmessage: TextField = new TextField();
                blockmessage.autoSize = TextFieldAutoSize.LEFT;
                blockmessage.defaultTextFormat = new TextFormat('Verdana', 36, 0xDEDEDE);
                blockmessage.text = "\n Your ad blocker\n works!";
                _overlay.addChild(blockmessage);
            }
        }

        private
        function onModulesLoaded(event: ExperienceEvent): void {
            _player.removeEventListener(ExperienceEvent.MODULES_LOADED, onModulesLoaded);
            _experienceModule = _player.getModule(APIModules.EXPERIENCE) as ExperienceModule;
            if (_experienceModule != null) {
                checkReady();
            }
        }

        public
        function setInterface(player: IEventDispatcher): void {
            _player = new BrightcoveModuleWrapper(player);
            _experienceModule = _player.getModule(APIModules.EXPERIENCE) as ExperienceModule;
            if (_experienceModule == null) {
                _player.addEventListener(ExperienceEvent.MODULES_LOADED, onModulesLoaded);
                _player.loadModules();
            } else {
                checkReady();
            }
        }
    }
}