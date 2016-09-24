--古代の歯車機械
--Ancient Gear Gadget
--Scripted by Eerie Code
function c18486927.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(18486927,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c18486927.limtg)
	e1:SetOperation(c18486927.limop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(18486927,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c18486927.nmtg)
	e3:SetOperation(c18486927.nmop)
	c:RegisterEffect(e3)
end

c18486927.gn={aux.Stringid(18486927,2),aux.Stringid(18486927,3),aux.Stringid(18486927,4),aux.Stringid(18486927,5),aux.Stringid(18486927,6),aux.Stringid(18486927,7),aux.Stringid(18486927,8),aux.Stringid(18486927,9),aux.Stringid(18486927,10),aux.Stringid(18486927,11)}
c18486927.gc={47985614,54497620,28002611,86281779,55010259,41172955,86445415,29021114,13839120,18486927}

function c18486927.limtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local opt=Duel.SelectOption(tp,1050,1051,1052)
	e:SetLabel(opt)
end
function c18486927.limop(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel()
	local t=TYPE_MONSTER
	if opt==1 then t=TYPE_SPELL 
	elseif opt==2 then t=TYPE_TRAP end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c18486927.aclimit)
	e1:SetTarget(c18486927.accon)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabel(t)
	Duel.RegisterEffect(e1,tp)
end
function c18486927.aclimit(e,re,tp)
	return re:IsActiveType(e:GetLabel()) and not re:GetHandler():IsImmuneToEffect(e)
end
function c18486927.accon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetAttacker() and Duel.GetAttacker():IsControler(tp)
end

function c18486927.nmfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x51)
end
function c18486927.nmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	--local opt=Duel.SelectOption(tp,c18486927.gn[1],c18486927.gn[2],c18486927.gn[3],c18486927.gn[4],c18486927.gn[5],c18486927.gn[6],c18486927.gn[7],c18486927.gn[8],c18486927.gn[9],c18486927.gn[10])+1
	--local nm=c18486927.gc[opt]
	--e:SetLabel(nm)
	--Duel.SetTargetParam(nm)
	local ac=0
	local lp=true
	while lp do
		ac=Duel.AnnounceCard(tp,TYPE_MONSTER)
		local tk=Duel.CreateToken(tp,ac)
		if c18486927.nmfil(tk) then lp=false end
	end
	--Debug.Message("Fusion Tag: "..ac)
	Duel.SetTargetParam(ac)
	e:SetLabel(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c18486927.nmop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(ac)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
