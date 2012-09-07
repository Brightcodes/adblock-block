Adblock blocker
===============

A swf plugin for a Brightcove Player that detects when an adblocker has been used to prevent advertising being shown in the player.

Requires the [Brightcove Player API SWC|http://support.brightcove.com/en/docs/flash-only-player-api-swc]

This works by trapping the error that would occur when attempting to use the advertising module that will occur if the advertising module was prevented from being downloaded.

This should be added to a player as a [required module|http://support.brightcove.com/en/docs/developing-player-templates#Modules].