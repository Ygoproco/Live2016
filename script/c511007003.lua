--Briar Pin-Seal
--coded by Lyris
--fixed by MLD
function c511007003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511007003.target)
	e1:SetOperation(c511007003.activate)
	c:RegisterEffect(e1)
	--forbidden
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_FORBIDDEN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0x7f,0x7f)
	e2:SetCondition(c511007003.bancon)
	e2:SetTarget(c511007003.bantg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_DISCARD_HAND)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,1)
	e3:SetCondition(c511007003.bancon)
	e3:SetTarget(c511007003.bantg)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
end
function c511007003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	e:SetLabelObject(nil)
end
function c511007003.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	c:RegisterFlagEffect(511007003,RESET_EVENT+0x1fe0000,0,0)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):Select(tp,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.HintSelection(g)
	tc:RegisterFlagEffect(511007003,RESET_EVENT+0x1de0000,0,0)
	e:SetLabelObject(tc)
	Duel.AdjustInstantly(c)
end
function c511007003.bancon(e)
	return e:GetHandler():GetFlagEffect(511007003)>0
end
function c511007003.bantg(e,c,re,r)
	return c==e:GetLabelObject():GetLabelObject() and c:GetFlagEffect(511007003)>0
end
